using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Runemark.Common
{
    /// <summary>
    /// This component rotates its transform.
    /// </summary>
    [AddComponentMenu("Dark Fantasy Kit/Rotator")]
    public class RMRotator : RMTransformer
    {
        public override string Title { get { return "Rotator"; } }
        public override string Description { get { return "This component rotates the transform.\nYou can activate this component by calling the Activate method from script."; } }

        public Vector3 axis = Vector3.up;
        public float start = 0;
        public float end = 90;

        public override void DoTransform(float position)
        {
            var curvePosition = AccelerationCurve.Evaluate(position);
                       
            var q = Quaternion.AngleAxis(Mathf.Lerp(start, end, curvePosition), axis);
            transform.localRotation = q;
        }
    }
}
