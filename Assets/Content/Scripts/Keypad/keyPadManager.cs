using UnityEngine;
using TMPro;

public class keyPadManager : MonoBehaviour
{
    [Header("Code Settings")]
    [SerializeField] private string correctCode = "";   // Set correct code in Inspector
    [SerializeField] private int maxCodeLength = 4;     // Set max character limit

    private string enteredCode = "";

    [SerializeField] private keyPadDoorController door;

    [Header("Optional Display")]
    [SerializeField] private TMP_Text codeDisplay;
    [SerializeField] private Color normalColor = Color.white;
    [SerializeField] private Color errorColor = Color.red;
    [SerializeField] private Color successColor = Color.green;

    [Header("Display Settings")]
    [SerializeField] private string defaultDisplayText = "Default Text Display";

    [Header("Timing Settings")]
    [SerializeField] private float resetDelay = 1.5f; // Time (in seconds) before display resets

    private void Start()
    {
        if (codeDisplay != null)
        {
            codeDisplay.text = defaultDisplayText;
            codeDisplay.color = normalColor;
        }
    }

    public void AddDigit(string digit)
    {
        if (enteredCode.Length < maxCodeLength)
        {
            enteredCode += digit;
            Debug.Log("Code so far: " + enteredCode);

            if (codeDisplay != null)
            {
                codeDisplay.text = enteredCode;
                codeDisplay.color = normalColor;
            }
        }
        else
        {
            if (codeDisplay != null)
            {
                codeDisplay.text = "ERROR";
                codeDisplay.color = errorColor;
            }
            Invoke(nameof(ResetCode), resetDelay);
        }
    }

    public void ForceCheckCode()
    {
        CheckCode();
    }

    private void CheckCode()
    {
        if (enteredCode == correctCode)
        {
            Debug.Log("Correct code entered. Unlocking.");
            if (codeDisplay != null)
            {
                codeDisplay.text = "UNLOCKED";
                codeDisplay.color = successColor;
            }

            if (door != null)
                door.OpenDoor();
        }
        else
        {
            Debug.Log("Incorrect code. Resetting.");
            if (codeDisplay != null)
            {
                codeDisplay.text = "ERROR";
                codeDisplay.color = errorColor;
            }
        }

        Invoke(nameof(ResetCode), resetDelay);
    }

    private void ResetCode()
    {
        enteredCode = "";
        if (codeDisplay != null)
        {
            codeDisplay.text = defaultDisplayText;
            codeDisplay.color = normalColor;
        }
    }
}
