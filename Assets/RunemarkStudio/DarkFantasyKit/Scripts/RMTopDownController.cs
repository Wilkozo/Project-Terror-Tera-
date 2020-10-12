using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

namespace Runemark.Common
{
    public class RMTopDownController : RMBase
    {
        public override string Title { get { return "Top-Down Character Controller"; } }
        public override string Description { get { return "Simple character controller for top-down demo scenes."; } }

        Animator _animator;
        NavMeshAgent _agent;

        private void OnEnable()
        {
            _animator = GetComponentInChildren<Animator>();
            if (_animator != null) _animator.applyRootMotion = false;
            _agent = GetComponent<NavMeshAgent>();
        }

        // Update is called once per frame
        void Update()
        {
            if (Input.GetMouseButton(0))
            {
                Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
                RaycastHit hit;
                if (Physics.Raycast(ray, out hit, 100))
                {
                    _agent.SetDestination(hit.point);
                }
            }

            if(_animator !=null)
                _animator.SetFloat("Speed", _agent.velocity.sqrMagnitude);
        }
    }
}