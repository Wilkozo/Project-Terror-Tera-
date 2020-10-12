using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Runemark.Common
{
    /// <summary>
    /// This component iterates through the given functions and activates them one by one.
    /// Only activates the next one if the previous one is finished.
    /// </summary>
    [AddComponentMenu("Dark Fantasy Kit/Sequencer")]
    public class RMTransformerSequencer : MonoBehaviour
    {
        [Tooltip("If this is enabled, the sequencer will start activating the transformers from back, in every odd activation time.")]
        public bool InverseRepeate;
        
        public List<RMFunction> List;

        public bool InProgress;

        int _index = 0;
        int _direction = 1;

        Coroutine _current;

        public void Activate()
        {
            if (InProgress) return;

            InProgress = true;
            _current = StartCoroutine(ActivateTransformer());
        }
                

        IEnumerator ActivateTransformer()
        {
            RMFunction current = List[_index];
            current.Activate();
            while (current.InProgress) yield return null;

            _index += _direction;

            if (_index < List.Count && _index >= 0)
            {                
                _current = StartCoroutine(ActivateTransformer());
            }
            else
            {
                _index = Mathf.Clamp(_index, 0, List.Count-1);

                InProgress = false;

                if (InverseRepeate) _direction *= -1;
                else _index = 0;               
            }
        }         
    }
}
