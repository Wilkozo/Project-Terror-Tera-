using System.Collections;
using UnityEngine;

public class PathFollower : MonoBehaviour
{
    public bool IsTrain;
    public float Speed = 30.0f;
    public Transform pathParent;
    Transform targetPoint;
    int index;
    Vector3 from;
    Vector3 to;
    bool rotating = false;
    float RotationTime; 

    void OnDrawGizmos()
    {

        for (int i = 0; i < pathParent.childCount; i++)
        {
            from = pathParent.GetChild(i).position;
            to = pathParent.GetChild((i + 1) % pathParent.childCount).position;
            Gizmos.color = new Color(0, 1, 0);
            Gizmos.DrawLine(from, to);
        }
    }

    // Use this for initialization
    void Start ()
    {
        index = 0;
        targetPoint = pathParent.GetChild(index);
    }
	
	// Update is called once per frame
	void Update ()
    {
        float Radians = 0.001f;
        float Magnitude = 0.001f;

        for (int i = 0; i < pathParent.childCount; i++)
        {
            from = pathParent.GetChild(i).position;
            to = pathParent.GetChild((i + 1) % pathParent.childCount).position;
        }

        transform.position = Vector3.MoveTowards(transform.position, targetPoint.position, Speed * Time.deltaTime);//Time.deltaTime);

        if (IsTrain == true)
        {
            Vector3 direction = transform.position - targetPoint.position;
            Quaternion rotation = Quaternion.LookRotation(direction); // check LOOK ROATION IS ZERO AT TIMES CAUSING A BUG
            rotating = true;
            if (rotating == true)
            {
                RotationTime += Time.deltaTime * 7;//2.7f;
                //                                                       targetPoint.rotation 0.1f * Time.deltaTime
                transform.rotation = Quaternion.Lerp(transform.rotation, rotation, RotationTime); // check
            }
            if (RotationTime > 1)
            {
                rotating = false;
            }



            //             speed
            //transform.rotation = Quaternion.Lerp(transform.rotation, rotation, -0.33f * 1);// Time.deltaTime);
        }

        //transform.rotation = Lerp(from, targetPoint, 1);

        //transform.position = Vector3.RotateTowards(from, to, Radians, Magnitude);


        //transform.position = Vector3.RotateTowards(transform.position, targetPoint.position, Radians, Magnitude);//targetPoint.position, Speed * 1);

        if (Vector3.Distance(transform.position, targetPoint.position) < 0.1f)
        {
            // Sets Next target...

            index++;
            index %= pathParent.childCount;
            targetPoint = pathParent.GetChild(index);
        }
	}
}
