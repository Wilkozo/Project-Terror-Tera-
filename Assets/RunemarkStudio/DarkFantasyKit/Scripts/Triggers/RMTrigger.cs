using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace Runemark.Common
{
    [RequireComponent(typeof(Collider))]
    [AddComponentMenu("Dark Fantasy Kit/Triggers/Simple Trigger")]
    public class RMTrigger : RMBase
    {
        public override string Title { get { return "Simple Trigger"; } }
        public override string Description { get { return "You can create simple OnTriggerEnter and OnTriggerExit events."; } }



        public string Tag;

        [Header("Trigger Enter & Exit")]
        public UnityEvent OnEnter;
        public UnityEvent OnExit;        

        void OnTriggerEnter(Collider other)
        {
            if (Validate(other))
            {
                OnEnter.Invoke();
            }
        }

        void OnTriggerExit(Collider other)
        {
            if (Validate(other))
            {
                OnExit.Invoke();
            }
        }

        protected bool Validate(Collider other)
        {
            return other.tag == Tag;
        }
    }
}
