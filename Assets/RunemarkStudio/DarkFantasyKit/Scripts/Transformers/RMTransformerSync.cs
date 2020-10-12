using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Runemark.Common
{
    /// <summary>
    /// This component syncronizea the activation of multiple Transfromer functionality.
    /// </summary>
    [AddComponentMenu("Dark Fantasy Kit/Syncronizer")]
    public class RMTransformerSync : RMFunction
    {
        public override string Title { get { return "Syncronizer"; } }
        public override string Description
        {
            get
            {
                return "This component syncronizea the activation of multiple Transfromer functionality. \n" +
                    "Just drop the Transformers you want to simultaneously activate, and call the Activate method of this component.";
            }
        }


        public List<RMTransformer> List;

        public override bool InProgress
        {
            get
            {
                return List.Find(x => x.InProgress) != null;                   
            }
        }      
        public override void Activate()
        {
            foreach (var t in List) t.Activate();
        }
        public override void Deactivate()
        {
            foreach (var t in List) t.Deactivate();
        }
    }
}
