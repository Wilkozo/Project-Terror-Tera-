using System;
using System.Collections.Generic;
using UnityEngine;

namespace Digger
{
    public static class DiggerPhysics
    {
        private static readonly Collider[] BufferOverlap = new Collider[32];
        private static readonly List<RaycastHit> HitBuffer = new List<RaycastHit>(128);
        private static readonly List<RaycastHit> HitBufferAuxiliary = new List<RaycastHit>(128);
        private static readonly RaycastHit[] SmallHitBufferArray = new RaycastHit[20];
        private static readonly RaycastHit[] BigHitBufferArray = new RaycastHit[1000];
        private static readonly HitComparer HitByDistanceComparer = new HitComparer();

        /// <summary>
        ///   <para>Casts a ray, from point origin, in direction direction, of length maxDistance, against all colliders in the Scene.</para>
        /// </summary>
        /// <param name="origin">The starting point of the ray in world coordinates.</param>
        /// <param name="direction">The direction of the ray.</param>
        /// <param name="maxDistance">The max distance the ray should check for collisions.</param>
        /// <param name="layerMask">A that is used to selectively ignore Colliders when casting a ray.</param>
        /// <param name="queryTriggerInteraction">Specifies whether this query should hit Triggers.</param>
        /// <returns>
        ///   <para>True if the ray intersects with a Collider, otherwise false.</para>
        /// </returns>
        public static bool Raycast(
            Vector3 origin,
            Vector3 direction,
            float maxDistance = float.PositiveInfinity,
            int layerMask = Physics.DefaultRaycastLayers,
            QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal)
        {
            return Raycast(new Ray(origin, direction), out _, maxDistance, layerMask, queryTriggerInteraction);
        }

        public static bool Raycast(
            Ray ray,
            float maxDistance = float.PositiveInfinity,
            int layerMask = Physics.DefaultRaycastLayers,
            QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal)
        {
            return Raycast(ray, out _, maxDistance, layerMask, queryTriggerInteraction);
        }

        public static bool Raycast(
            Vector3 origin,
            Vector3 direction,
            out RaycastHit raycastHit,
            float maxDistance = float.PositiveInfinity,
            int layerMask = Physics.DefaultRaycastLayers,
            QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal)
        {
            return Raycast(new Ray(origin, direction), out raycastHit, maxDistance, layerMask, queryTriggerInteraction);
        }

        public static bool Raycast(Ray ray,
                                   out RaycastHit raycastHit,
                                   float maxDistance = float.PositiveInfinity,
                                   int layerMask = Physics.DefaultRaycastLayers,
                                   QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal)
        {
            HitBufferAuxiliary.Clear();
            RaycastNonAlloc(1, ray.origin, ray.direction, HitBufferAuxiliary, maxDistance, layerMask, queryTriggerInteraction);
            if (HitBufferAuxiliary.Count == 0) {
                raycastHit = default;
                return false;
            }

            raycastHit = HitBufferAuxiliary[0];
            return true;
        }

        public static RaycastHit[] RaycastAll(
            Ray ray,
            float maxDistance = float.PositiveInfinity,
            int layerMask = Physics.DefaultRaycastLayers,
            QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal)
        {
            return RaycastAll(ray.origin, ray.direction, maxDistance, layerMask, queryTriggerInteraction);
        }

        public static RaycastHit[] RaycastAll(
            Vector3 origin,
            Vector3 direction,
            float maxDistance = float.PositiveInfinity,
            int layerMask = Physics.DefaultRaycastLayers,
            QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal)
        {
            HitBufferAuxiliary.Clear();
            RaycastNonAlloc(10000, origin, direction, HitBufferAuxiliary, maxDistance, layerMask, queryTriggerInteraction);
            return HitBufferAuxiliary.ToArray();
        }

        public static int RaycastNonAlloc(
            Ray ray,
            RaycastHit[] results,
            float maxDistance = float.PositiveInfinity,
            int layerMask = Physics.DefaultRaycastLayers,
            QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal)
        {
            return RaycastNonAlloc(ray.origin, ray.direction, results, maxDistance, layerMask, queryTriggerInteraction);
        }

        /// <summary>
        ///   <para>Cast a ray through the Scene and store the hits into the buffer.</para>
        /// </summary>
        /// <param name="origin">The starting point and direction of the ray.</param>
        /// <param name="results">The buffer to store the hits into.</param>
        /// <param name="direction">The direction of the ray.</param>
        /// <param name="maxDistance">The max distance the rayhit is allowed to be from the start of the ray.</param>
        /// <param name="layerMask">A that is used to selectively ignore colliders when casting a ray.</param>
        /// <param name="queryTriggerInteraction">Specifies whether this query should hit Triggers.</param>
        /// <returns>
        ///   <para>The amount of hits stored into the results buffer.</para>
        /// </returns>
        public static int RaycastNonAlloc(
            Vector3 origin,
            Vector3 direction,
            RaycastHit[] results,
            float maxDistance = float.PositiveInfinity,
            int layerMask = Physics.DefaultRaycastLayers,
            QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal)
        {
            HitBufferAuxiliary.Clear();
            RaycastNonAlloc(results.Length, origin, direction, HitBufferAuxiliary, maxDistance, layerMask, queryTriggerInteraction);
            for (var i = 0; i < results.Length && i < HitBufferAuxiliary.Count; ++i) {
                results[i] = HitBufferAuxiliary[i];
            }

            return Math.Min(results.Length, HitBufferAuxiliary.Count);
        }

        private static void RaycastNonAlloc(
            int maxCount,
            Vector3 origin,
            Vector3 direction,
            List<RaycastHit> results,
            float maxDistance = float.PositiveInfinity,
            int layerMask = Physics.DefaultRaycastLayers,
            QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal)
        {
            var buffer = maxCount == 1 ? SmallHitBufferArray : BigHitBufferArray;
            var hitCount = Physics.RaycastNonAlloc(origin, direction, buffer, maxDistance, layerMask, queryTriggerInteraction);
            HitBuffer.Clear();
            for (var i = 0; i < buffer.Length && i < hitCount; ++i) {
                HitBuffer.Add(buffer[i]);
            }

            HitBuffer.Sort(HitByDistanceComparer);

            var needAnotherRaycast = false;
            var newOrigin = Vector3.zero;
            var newDistance = 0f;
            for (var i = 0; i < HitBuffer.Count && results.Count < maxCount; i++) {
                var hit = HitBuffer[i];

                // Always ignore TerrainColliderHoleComponents
                if (hit.collider.isTrigger && hit.collider.GetComponent<TerrainColliderHoleComponent>()) {
                    continue;
                }

                // We hit the terrain
                if (hit.collider is TerrainCollider && IsInColliderHole(hit.point)) {
                    // But we hit Digger mesh right after, so we add it to be sure we don't miss it in the next raycast
                    if (i < HitBuffer.Count - 1 && IsNextTo(hit, HitBuffer[i + 1])) {
                        results.Add(HitBuffer[i + 1]);
                    }

                    // We need to perform another Raycast to be sure we don't miss the next terrain surface
                    needAnotherRaycast = true;
                    newOrigin = hit.point + direction.normalized * 0.01f;
                    newDistance = maxDistance - hit.distance;
                    break;
                }

                // That was a normal hit, we can return it
                results.Add(hit);
            }

            if (needAnotherRaycast && results.Count < maxCount) {
                RaycastNonAlloc(maxCount, newOrigin, direction, results, newDistance, layerMask, queryTriggerInteraction);
            }
        }

        private static bool IsInColliderHole(Vector3 point)
        {
            var count = Physics.OverlapSphereNonAlloc(point, 0.01f, BufferOverlap, Physics.DefaultRaycastLayers, QueryTriggerInteraction.Collide);
            for (var i = 0; i < count; i++) {
                var collider = BufferOverlap[i];
                if (collider.isTrigger && collider.GetComponent<TerrainColliderHoleComponent>()) return true;
            }

            return false;
        }

        private static bool IsNextTo(RaycastHit hit, RaycastHit nextHit)
        {
            if (nextHit.collider.isTrigger && nextHit.collider.GetComponent<TerrainColliderHoleComponent>()) {
                return false;
            }

            return (nextHit.point - hit.point).sqrMagnitude < 0.011f;
        }

        private class HitComparer : IComparer<RaycastHit>
        {
            public int Compare(RaycastHit x, RaycastHit y)
            {
                return x.distance.CompareTo(y.distance);
            }
        }
    }
}