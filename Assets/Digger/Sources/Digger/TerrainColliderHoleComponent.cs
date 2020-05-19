using UnityEngine;

namespace Digger
{
    [ExecuteInEditMode]
    public class TerrainColliderHoleComponent : MonoBehaviour
    {
#if !UNITY_2019_3_OR_NEWER
        [SerializeField] public DiggerSystem Digger;
        [SerializeField] public TerrainCollider TerrainCollider;

        private void Awake()
        {
            // For retro-compatibility
            if (!Digger) {
                Digger = GetComponentInParent<DiggerSystem>();
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (Digger.ColliderStates.TryGetValue(other, out var state)) {
                state++;
                Digger.ColliderStates[other] = state;
            } else {
                state = 1;
                Digger.ColliderStates.Add(other, state);
            }

            if (state == 1) {
                Physics.IgnoreCollision(other, TerrainCollider, true);
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (Digger.ColliderStates.TryGetValue(other, out var state)) {
                state--;
                if (state == 0) {
                    Digger.ColliderStates.Remove(other);
                } else {
                    Digger.ColliderStates[other] = state;
                }
            } else {
                state = 0;
            }

            if (state == 0) {
                Physics.IgnoreCollision(other, TerrainCollider, false);
            }
        }
#endif
    }
}