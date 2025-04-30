using UnityEngine;

public class keyPadButton : MonoBehaviour
{
    public string digit;
    public float pressDistance = 0.05f;
    public float returnSpeed = 5f;

    private Vector3 originalPosition;
    private bool isPressed = false;

    private keyPadManager keypad;

    private void Start()
    {
        originalPosition = transform.localPosition;
        keypad = GetComponentInParent<keyPadManager>();
    }

    private void OnMouseDown()
    {
        Debug.Log("🔘 Button " + digit + " clicked");

        if (keypad != null)
        {
            if (digit == "Enter")
            {
                keypad.ForceCheckCode();
            }
            else
            {
                keypad.AddDigit(digit);
            }
        }

        // Push back along local -X
        transform.localPosition = originalPosition + transform.right * pressDistance;

        isPressed = true;
    }

    private void Update()
    {
        if (isPressed)
        {
            transform.localPosition = Vector3.Lerp(transform.localPosition, originalPosition, Time.deltaTime * returnSpeed);
            if (Vector3.Distance(transform.localPosition, originalPosition) < 0.001f)
            {
                transform.localPosition = originalPosition;
                isPressed = false;
                Debug.Log("🔁 Button " + digit + " returned to position");
            }
        }
    }
}
