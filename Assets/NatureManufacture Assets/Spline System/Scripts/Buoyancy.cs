using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class Buoyancy : MonoBehaviour
{
    public float buoyancy = 20;
    public float viscosity = 1;
    public float viscosityAngular = 1;

    public LayerMask layer;

    public BoxCollider boxCollider;

    new Rigidbody rigidbody;
    static RamSpline[] ramSplines;
    static LakePolygon[] lakePolygons;

    Vector3[] vertices = new Vector3[8];
    Vector3[] verticesMatrix = new Vector3[8];
    Vector3 lowestPoint;
    Vector3 center = Vector3.zero;

    public bool debug = false;

    void Start()
    {
        rigidbody = GetComponent<Rigidbody>();
        if (ramSplines == null)
            ramSplines = FindObjectsOfType<RamSpline>();
        if (lakePolygons == null)
            lakePolygons = FindObjectsOfType<LakePolygon>();

        boxCollider = GetComponent<BoxCollider>();
        vertices[0] = boxCollider.center + new Vector3(boxCollider.size.x, boxCollider.size.y, boxCollider.size.z) * 0.5f;
        vertices[1] = boxCollider.center + new Vector3(-boxCollider.size.x, boxCollider.size.y, boxCollider.size.z) * 0.5f;
        vertices[2] = boxCollider.center + new Vector3(-boxCollider.size.x, boxCollider.size.y, -boxCollider.size.z) * 0.5f;
        vertices[3] = boxCollider.center + new Vector3(boxCollider.size.x, boxCollider.size.y, -boxCollider.size.z) * 0.5f;
        vertices[4] = boxCollider.center + new Vector3(boxCollider.size.x, -boxCollider.size.y, boxCollider.size.z) * 0.5f;
        vertices[5] = boxCollider.center + new Vector3(-boxCollider.size.x, -boxCollider.size.y, boxCollider.size.z) * 0.5f;
        vertices[6] = boxCollider.center + new Vector3(-boxCollider.size.x, -boxCollider.size.y, -boxCollider.size.z) * 0.5f;
        vertices[7] = boxCollider.center + new Vector3(boxCollider.size.x, -boxCollider.size.y, -boxCollider.size.z) * 0.5f;

    }

    private void FixedUpdate()
    {

        WaterPhysics();

    }


    public void WaterPhysics()
    {

        Ray ray = new Ray();
        ray.direction = Vector3.up;
        RaycastHit hit;


        List<MeshCollider> meshColliders = new List<MeshCollider>();
        foreach (var item in ramSplines)
        {
            MeshCollider collider = item.gameObject.AddComponent<MeshCollider>();
            meshColliders.Add(collider);

        }

        foreach (var item in lakePolygons)
        {
            MeshCollider collider = item.gameObject.AddComponent<MeshCollider>();
            meshColliders.Add(collider);

        }

        bool backFace = Physics.queriesHitBackfaces;
        Physics.queriesHitBackfaces = true;

        var thisMatrix = transform.localToWorldMatrix;

        lowestPoint = vertices[0];
        float minY = float.MaxValue;
        for (int i = 0; i < vertices.Length; i++)
        {
            verticesMatrix[i] = thisMatrix.MultiplyPoint3x4(vertices[i]);

            if (minY > verticesMatrix[i].y)
            {
                lowestPoint = verticesMatrix[i];
                minY = lowestPoint.y;
            }
        }

        ray.origin = lowestPoint;

        center = Vector3.zero;

        if (Physics.Raycast(ray, out hit, 100, layer))
        {
            float width = 2;
            int verticesCount = 0;

            Vector3 velocity = rigidbody.velocity;

            Vector3 velocityDirection = velocity.normalized;

            minY = hit.point.y;

            for (int i = 0; i < verticesMatrix.Length; i++)
            {
                if (verticesMatrix[i].y <= minY)
                {
                    center += verticesMatrix[i];
                    verticesCount++;
                }
            }
            center /= verticesCount;
            //Debug.Log(minY - center.y);
            rigidbody.AddForceAtPosition(Vector3.up * buoyancy * (minY - center.y), center);

            rigidbody.AddForce(velocity * -1 * viscosity);


            if (velocity.magnitude > 0.01f)
            {
                Vector3 v1 = Vector3.Cross(velocity, new Vector3(1, 1, 1)).normalized;

                Vector3 v2 = Vector3.Cross(velocity, v1).normalized;


                Vector3 pointFront = transform.position + (velocity.normalized * 10);
                Ray rayCollider;

                RaycastHit hitCollider;
                for (float x = -width; x < width; x += 0.3f)
                {
                    for (float y = -width; y < width; y += 0.3f)
                    {
                        Vector3 start = pointFront + (v1 * x) + (v2 * y);
                        rayCollider = new Ray(start, -velocityDirection);

                        //Debug.Log(start + " " + v1 + " " + v2);

                        // Debug.DrawRay(start, -velocityDirection*50, Color.cyan, 0.1f);
                        if (boxCollider.Raycast(rayCollider, out hitCollider, 50))
                        {
                            Vector3 pointVelocity = rigidbody.GetPointVelocity(hitCollider.point);
                            rigidbody.AddForceAtPosition(-pointVelocity * viscosityAngular, hitCollider.point);
                            //Debug.Log(hitCollider.point);
                            if (debug)
                                Debug.DrawRay(hitCollider.point, -pointVelocity * viscosityAngular, Color.red, 0.1f);
                        }
                    }
                }
            }

            RamSpline ramSpline = hit.collider.GetComponent<RamSpline>();
            LakePolygon lakePolygon = hit.collider.GetComponent<LakePolygon>();
            if (ramSpline != null)
            {
                Mesh meshRam = ramSpline.meshfilter.sharedMesh;
                int verticeId1 = meshRam.triangles[hit.triangleIndex * 3];

                Vector3 verticeDirection = ramSpline.verticeDirection[verticeId1];

                Vector2 uv4 = meshRam.uv4[verticeId1];

                verticeDirection = verticeDirection * uv4.y - new Vector3(verticeDirection.z, verticeDirection.y, -verticeDirection.x) * uv4.x;

                rigidbody.AddForce(new Vector3(verticeDirection.x, 0, verticeDirection.z) * ramSpline.floatSpeed);


                if (debug)
                    Debug.DrawRay(center, Vector3.up * buoyancy * (minY - center.y) * 5, Color.blue);
                if (debug)
                    Debug.DrawRay(transform.position, velocity * -1 * viscosity * 5, Color.magenta);
                if (debug)
                    Debug.DrawRay(transform.position, velocity * 5, Color.grey);
                if (debug)
                    Debug.DrawRay(transform.position, rigidbody.angularVelocity * 5, Color.black);
            }
            else if (lakePolygon != null)
            {
                Mesh meshLake = lakePolygon.meshfilter.sharedMesh;
                int verticeId1 = meshLake.triangles[hit.triangleIndex * 3];


                Vector2 uv4 = -meshLake.uv4[verticeId1];

                //Debug.Log(uv4);
                Vector3 verticeDirection = new Vector3(uv4.x, 0, uv4.y);// Vector3.forward * uv4.y + new Vector3(0, 0, 1) * uv4.x;

                rigidbody.AddForce(new Vector3(verticeDirection.x, 0, verticeDirection.z) * lakePolygon.floatSpeed);
                if (debug)
                    Debug.DrawRay(transform.position + Vector3.up, verticeDirection * 5, Color.red);

                if (debug)
                    Debug.DrawRay(center, Vector3.up * buoyancy * (minY - center.y) * 5, Color.blue);
                if (debug)
                    Debug.DrawRay(transform.position, velocity * -1 * viscosity * 5, Color.magenta);
                if (debug)
                    Debug.DrawRay(transform.position, velocity * 5, Color.grey);
                if (debug)
                    Debug.DrawRay(transform.position, rigidbody.angularVelocity * 5, Color.black);

            }
        }




        foreach (var item in meshColliders)
        {
            Destroy(item);
        }
        Physics.queriesHitBackfaces = backFace;
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;

        if (boxCollider != null)
        {

            var thisMatrix = transform.localToWorldMatrix;
            Gizmos.DrawSphere(thisMatrix.MultiplyPoint3x4(boxCollider.center + new Vector3(boxCollider.size.x, boxCollider.size.y, boxCollider.size.z) * 0.5f), .05f);
            Gizmos.DrawSphere(thisMatrix.MultiplyPoint3x4(boxCollider.center + new Vector3(-boxCollider.size.x, boxCollider.size.y, boxCollider.size.z) * 0.5f), .05f);
            Gizmos.DrawSphere(thisMatrix.MultiplyPoint3x4(boxCollider.center + new Vector3(-boxCollider.size.x, boxCollider.size.y, -boxCollider.size.z) * 0.5f), .05f);
            Gizmos.DrawSphere(thisMatrix.MultiplyPoint3x4(boxCollider.center + new Vector3(boxCollider.size.x, boxCollider.size.y, -boxCollider.size.z) * 0.5f), .05f);
            Gizmos.DrawSphere(thisMatrix.MultiplyPoint3x4(boxCollider.center + new Vector3(boxCollider.size.x, -boxCollider.size.y, boxCollider.size.z) * 0.5f), .05f);
            Gizmos.DrawSphere(thisMatrix.MultiplyPoint3x4(boxCollider.center + new Vector3(-boxCollider.size.x, -boxCollider.size.y, boxCollider.size.z) * 0.5f), .05f);
            Gizmos.DrawSphere(thisMatrix.MultiplyPoint3x4(boxCollider.center + new Vector3(-boxCollider.size.x, -boxCollider.size.y, -boxCollider.size.z) * 0.5f), .05f);
            Gizmos.DrawSphere(thisMatrix.MultiplyPoint3x4(boxCollider.center + new Vector3(boxCollider.size.x, -boxCollider.size.y, -boxCollider.size.z) * 0.5f), .05f);
        }

        if (lowestPoint != null)
        {
            Gizmos.color = Color.blue;
            Gizmos.DrawSphere(lowestPoint, .08f);
        }

        if (center != null)
        {
            Gizmos.color = Color.green;
            Gizmos.DrawSphere(center, .08f);

        }
    }

}
