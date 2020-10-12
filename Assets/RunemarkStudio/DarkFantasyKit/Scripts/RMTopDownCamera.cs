using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Runemark.Common
{
    public class RMTopDownCamera : RMBase
    {
        public override string Title { get { return "Top-Down Camera Controller"; } }
        public override string Description { get { return "Simple camera controller for top-down demo scenes."; } }

        public float height = 20;
        public float distance = 15;
        public Transform target;
        Camera _cam;

        private void OnEnable()
        {
            _cam = GetComponentInChildren<Camera>();
        }

        void Update()
        {
            Vector3 pos = target.position;
            pos.y += height;
            pos.z -= distance;

            transform.position = pos;
            _cam.transform.LookAt(target.position);
        }
    }
}
