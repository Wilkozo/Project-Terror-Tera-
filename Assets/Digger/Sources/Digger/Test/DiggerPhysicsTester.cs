using UnityEngine;

namespace Digger.Test
{
    public class DiggerPhysicsTester : MonoBehaviour
    {
        private void OnDrawGizmos()
        {
            var ray = new Ray(new Vector3(20f, 5f, 0f), Vector3.forward);

            Gizmos.DrawLine(ray.origin, ray.origin + ray.direction * 400f);
            if (DiggerPhysics.Raycast(ray, out var hit1, 400f)) {
                Gizmos.DrawCube(hit1.point, Vector3.one);
            }

            ray = new Ray(new Vector3(60f, 5f, 0f), Vector3.forward);
            Gizmos.DrawLine(ray.origin, ray.origin + ray.direction * 400f);
            var hits = DiggerPhysics.RaycastAll(ray, 400f);
            foreach (var hit in hits) {
                Gizmos.DrawSphere(hit.point, 1f);
            }

            ray = new Ray(new Vector3(100f, 5f, 0f), Vector3.forward);
            Gizmos.DrawLine(ray.origin, ray.origin + ray.direction * 400f);
            var hits2 = new RaycastHit[1000];
            var count = DiggerPhysics.RaycastNonAlloc(ray, hits2, 400f);
            for (var i = 0; i < count; ++i) {
                Gizmos.DrawSphere(hits2[i].point, 1f);
            }
        }
    }
}