using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Runemark.Common
{
    /// <summary>
    /// This component translates the target transform from the start position to the end position.
    /// </summary>   
    [AddComponentMenu("Dark Fantasy Kit/Translator")]
    public class RMTranslator : RMTransformer
    {
        public override string Title { get { return "Translator"; } }
        public override string Description
        {
            get
            {
                return "This component translates the target transform from the start position to the end position. \n"+
                    "You can activate this component by calling the Activate method from script.";
            }
        }

        public Transform Target;
        public Vector3 Start = Vector3.zero;
        public Vector3 End = Vector3.zero;

        public override void DoTransform(float position)
        {
            float curvePosition = AccelerationCurve.Evaluate(position);
            Target.localPosition = Vector3.Lerp(Start, End, curvePosition);
        }
    }
}


