using UnityEngine;

namespace Runemark.Common
{
    /// <summary>
    /// This component toggles the mesh renderer on the same object.
    /// </summary>
    [AddComponentMenu("Dark Fantasy Kit/Renderer Toggle")]
    public class RMRendererToggle : RMFunction
    {
        public override string Title { get { return "Renderer Toggle"; } }
        public override string Description
        {
            get
            {
                return "This component toggles the mesh renderer on the same object. \n" +
                    "You can activate this component by calling the Activate method from script.\n"+
                    "You can also call the Toggle (bool visible) method.";
            }
        }

        public override bool InProgress { get { return false; } }

        MeshRenderer _renderer
        {
            get
            {
                if(__renderer== null)
                    __renderer = GetComponent<MeshRenderer>();
                return __renderer;
            }
        }
        MeshRenderer __renderer;

        public void Toggle(bool visible)
        {            
            _renderer.enabled = visible;
        }

        public override void Activate()
        {
            _renderer.enabled = !_renderer.enabled;
        }

        public override void Deactivate()
        {
            _renderer.enabled = false;
        }
    }
}