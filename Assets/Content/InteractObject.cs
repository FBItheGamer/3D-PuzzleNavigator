using UnityEngine;
using UnityEngine.Events;

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

    }
}
