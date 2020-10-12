using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace Runemark.Common
{
    [AddComponentMenu("Dark Fantasy Kit/Triggers/Trigger with Key Press")]
    public class RMTriggerKey : RMTrigger
    {
        public override string Title { get { return "Key Trigger"; } }
        public override string Description { get { return "If the player presses the given key the OnKeyPressed event invokes. The player has to stay in the trigger area."; } }


        [Header("Key Press")]
        public KeyCode Key;
        public UnityEvent OnKeyPressed;


        void OnTriggerStay(Collider other)
        {
            if (Validate(other) && Input.GetKeyUp(Key))
            {
                OnKeyPressed.Invoke();
            }
        }
    }
}