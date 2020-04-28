using System;
using System.Diagnostics;
using System.IO;
using Unity.Collections;
using Unity.Mathematics;
using UnityEngine;

namespace Digger
{
    public static class Utils
    {
        public static class Profiler
        {
            [Conditional("DIGGER_PROFILING")]
            public static void BeginSample(string name)
            {
                UnityEngine.Profiling.Profiler.BeginSample("[Dig] " + name);
            }

            [Conditional("DIGGER_PROFILING")]
            public static void EndSample()
            {
                UnityEngine.Profiling.Profiler.EndSample();
            }
        }

        public static class D
        {
            [Conditional("DIGGER_DEBUGGING")]
            public static void Log(string message)
            {
                UnityEngine.Debug.Log(message);
            }
        }

        public static bool Approximately(Color a, Color b)
        {
            return Math.Abs(a.r - b.r) < 1e-5f &&
                   Math.Abs(a.g - b.g) < 1e-5f &&
                   Math.Abs(a.b - b.b) < 1e-5f &&
                   Math.Abs(a.a - b.a) < 1e-5f;
        }

        public static bool Approximately(Vector3 a, Vector3 b)
        {
            return Math.Abs(a.x - b.x) < 1e-5f &&
                   Math.Abs(a.y - b.y) < 1e-5f &&
                   Math.Abs(a.z - b.z) < 1e-5f;
        }

        public static bool Approximately(float3 a, float3 b)
        {
            return Math.Abs(a.x - b.x) < 1e-5f &&
                   Math.Abs(a.y - b.y) < 1e-5f &&
                   Math.Abs(a.z - b.z) < 1e-5f;
        }

        public static float3 Cross(float3 left, float3 right)
        {
            return new float3(left.y * right.z - left.z * right.y,
                              left.z * right.x - left.x * right.z,
                              left.x * right.y - left.y * right.x);
        }

        public static bool AreColinear(float3 a, float3 b, float3 c)
        {
            return Approximately(Cross(b - a, c - a), float3.zero);
        }

        public static float3 Normalize(float3 vec)
        {
            var m = Math.Sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
            if (m < 1e-6) {
                return float3.zero;
            }

            return vec / (float) m;
        }

        public static float BilinearInterpolate(float f00, float f01, float f10, float f11, float x, float y)
        {
            var oneMinX = 1.0f - x;
            var oneMinY = 1.0f - y;
            return oneMinX * (oneMinY * f00 + y * f01) +
                   x * (oneMinY * f10 + y * f11);
        }

        public static Vector3 TriangleInterpolate(int2 a, int2 b, int2 c, int2 p)
        {
            var di = (b.y - c.y) * (a.x - c.x) + (c.x - b.x) * (a.y - c.y);
            if (di == 0)
                return -Vector3.one;

            var d = (double) di;
            var wa = ((b.y - c.y) * (p.x - c.x) + (c.x - b.x) * (p.y - c.y)) / d;
            var wb = ((c.y - a.y) * (p.x - c.x) + (a.x - c.x) * (p.y - c.y)) / d;
            var wc = 1 - wa - wb;
            return new Vector3((float) wa, (float) wb, (float) wc);
        }

        public static int2 Min(int2 a, int2 b, int2 c)
        {
            return new int2(Math.Min(a.x, Math.Min(b.x, c.x)), Math.Min(a.y, Math.Min(b.y, c.y)));
        }

        public static int2 Max(int2 a, int2 b, int2 c)
        {
            return new int2(Math.Max(a.x, Math.Max(b.x, c.x)), Math.Max(a.y, Math.Max(b.y, c.y)));
        }

        public static T[] ToArray<T>(NativeArray<T> src, int length) where T : struct
        {
            var dst = new T[length];
            NativeArray<T>.Copy(src, dst, length);
            return dst;
        }

        public static byte[] GetBytes(string path)
        {
#if ((!UNITY_ANDROID && !UNITY_WEBGL) || UNITY_EDITOR)
            return File.Exists(path) ? File.ReadAllBytes(path) : null;
#else
            var uri = path;
            if (!uri.StartsWith("jar:") && !uri.StartsWith("file:")) {
                if (File.Exists(uri)) {
                    uri = Path.GetFullPath(uri);
                }

                uri = $"file://{uri}";
            }

            using (var webRequest = UnityEngine.Networking.UnityWebRequest.Get(uri)) {
                var op = webRequest.SendWebRequest();
                while (!op.isDone) {
                }

                if (!webRequest.isNetworkError) {
                    var data = webRequest.downloadHandler.data;
                    return data != null && data.Length > 0 ? data : null;
                }

                UnityEngine.Debug.LogError($"Failed to load URI '{uri}' with error: {webRequest.error}");

                return File.Exists(uri) ? File.ReadAllBytes(path) : null;
            }
#endif
        }
    }
}