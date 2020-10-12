using UnityEngine;
using UnityEngine.AI;

namespace Runemark.Common
{
    /// <summary>
    /// This component toggles the mesh renderer on the same object.
    /// </summary>
    [AddComponentMenu("Dark Fantasy Kit/Collider Toggle")]
    public class RMColliderToggle : RMFunction
    {
        public override string Title { get { return "Collider Toggle"; } }
        public override string Description
        {
            get
            {
                return "This component toggles the collider on the same object. \n" +
                    "You can activate this component by calling the Activate method from script.\n"+
                    "You can also call the Toggle (bool visible) method.";
            }
        }

        public override bool InProgress { get { return false; } }

        Collider _collider
        {
            get
            {
                if (__collider == null)
                {
                    __collider = GetComponent<Collider>();
                    _navMeshObstacle = __collider.GetComponent<NavMeshObstacle>();
                }
                return __collider;
            }
        }
        Collider __collider;
        NavMeshObstacle _navMeshObstacle;

        public void Toggle(bool visible)
        {
            _collider.enabled = visible;
            if (_navMeshObstacle != null) _navMeshObstacle.enabled = _collider.enabled;
        }

        public override void Activate()
        {
            _collider.enabled = !_collider.enabled;
            if (_navMeshObstacle != null) _navMeshObstacle.enabled = _collider.enabled;
        }

        public override void Deactivate()
        {
            _collider.enabled = false;
            if (_navMeshObstacle != null) _navMeshObstacle.enabled = _collider.enabled;
        }
    }
}