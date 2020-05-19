using UnityEngine;

namespace Digger.Test
{
    public class PhysicsTest
    {
        private void Foo()
        {
            Ray ray = new Ray();
            DiggerPhysics.Raycast(ray);

            if (Physics.Raycast(ray)) {
            }

            bool b;
            b = Physics.Raycast(ray);
            b = Physics.Raycast(ray, 10f);
            b = Physics.Raycast(ray, 10f, 3);
            b = Physics.Raycast(ray, 10f, 3, QueryTriggerInteraction.Collide);
            b = Physics.Raycast(ray.origin, ray.direction);
            b = Physics.Raycast(ray.origin, ray.direction, 10f);
            b = Physics.Raycast(ray.origin, ray.direction, 10f, 3);
            b = Physics.Raycast(ray.origin, ray.direction, 10f, 3, QueryTriggerInteraction.Collide);

            RaycastHit hit;
            b = Physics.Raycast(ray, out hit);
            b = Physics.Raycast(ray, out hit, 10f);
            b = Physics.Raycast(ray, out hit, 10f, 3);
            b = Physics.Raycast(ray, out hit, 10f, 3, QueryTriggerInteraction.Collide);
            b = Physics.Raycast(ray.origin, ray.direction, out hit);
            b = Physics.Raycast(ray.origin, ray.direction, out hit, 10f);
            b = Physics.Raycast(ray.origin, ray.direction, out hit, 10f, 3);
            b = Physics.Raycast(ray.origin, ray.direction, out hit, 10f, 3, QueryTriggerInteraction.Collide);

            RaycastHit[] result;
            result = Physics.RaycastAll(ray);
            result = Physics.RaycastAll(ray, 10f);
            result = Physics.RaycastAll(ray, 10f, 3);
            result = Physics.RaycastAll(ray, 10f, 3, QueryTriggerInteraction.Collide);
            result = Physics.RaycastAll(ray.origin, ray.direction);
            result = Physics.RaycastAll(ray.origin, ray.direction, 10f);
            result = Physics.RaycastAll(ray.origin, ray.direction, 10f, 3);
            result = Physics.RaycastAll(ray.origin, ray.direction, 10f, 3, QueryTriggerInteraction.Collide);

            int count;
            count = Physics.RaycastNonAlloc(ray, result);
            count = Physics.RaycastNonAlloc(ray, result, 10f);
            count = Physics.RaycastNonAlloc(ray, result, 10f, 3);
            count = Physics.RaycastNonAlloc(ray, result, 10f, 3, QueryTriggerInteraction.Collide);
            count = Physics.RaycastNonAlloc(ray.origin, ray.direction, result);
            count = Physics.RaycastNonAlloc(ray.origin, ray.direction, result, 10f);
            count = Physics.RaycastNonAlloc(ray.origin, ray.direction, result, 10f, 3);
            count = Physics.RaycastNonAlloc(ray.origin, ray.direction, result, 10f, 3, QueryTriggerInteraction.Collide);
        }
    }
}