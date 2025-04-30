using System.Security.Cryptography.X509Certificates;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem.Switch;
using UnityEngine.UI;

public class InteractObject : MonoBehaviour
{
    public string interactiontext;
    public UnityEvent onInteract;

    public string GetInteractionText()
    {
        return interactiontext;
    }

    public void OnInteract()
    {
        onInteract.Invoke();
        Debug.Log("Interact Action Taken");
    }
}
