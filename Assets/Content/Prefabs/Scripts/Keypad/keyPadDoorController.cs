using UnityEngine;

public class keyPadDoorController : MonoBehaviour
{
    [Header("Left Door Settings")]
    public Transform leftDoor;
    public Vector3 leftSlideDirection = Vector3.left;

    [Header("Right Door Settings")]
    public Transform rightDoor;
    public Vector3 rightSlideDirection = Vector3.right;

    [Header("Slide Settings")]
    public float slideDistance = 2f;
    public float slideSpeed = 2f;
    public float autoCloseDelay = 3f;

    private Vector3 leftClosedPos;
    private Vector3 leftOpenPos;
    private Vector3 rightClosedPos;
    private Vector3 rightOpenPos;

    private bool isOpening = false;
    private bool isClosing = false;

    void Start()
    {
        leftClosedPos = leftDoor.position;
        rightClosedPos = rightDoor.position;

        leftOpenPos = leftClosedPos + leftDoor.TransformDirection(leftSlideDirection.normalized) * slideDistance;
        rightOpenPos = rightClosedPos + rightDoor.TransformDirection(rightSlideDirection.normalized) * slideDistance;
    }

    void Update()
    {
        if (isOpening)
        {
            leftDoor.position = Vector3.MoveTowards(leftDoor.position, leftOpenPos, slideSpeed * Time.deltaTime);
            rightDoor.position = Vector3.MoveTowards(rightDoor.position, rightOpenPos, slideSpeed * Time.deltaTime);

            if (Vector3.Distance(leftDoor.position, leftOpenPos) < 0.01f &&
                Vector3.Distance(rightDoor.position, rightOpenPos) < 0.01f)
            {
                isOpening = false;
                Invoke(nameof(CloseDoor), autoCloseDelay);
            }
        }

        if (isClosing)
        {
            leftDoor.position = Vector3.MoveTowards(leftDoor.position, leftClosedPos, slideSpeed * Time.deltaTime);
            rightDoor.position = Vector3.MoveTowards(rightDoor.position, rightClosedPos, slideSpeed * Time.deltaTime);

            if (Vector3.Distance(leftDoor.position, leftClosedPos) < 0.01f &&
                Vector3.Distance(rightDoor.position, rightClosedPos) < 0.01f)
            {
                isClosing = false;
            }
        }
    }

    public void OpenDoor()
    {
        isOpening = true;
        isClosing = false;
    }

    private void CloseDoor()
    {
        isClosing = true;
    }
}
