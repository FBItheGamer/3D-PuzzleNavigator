using System.Security.Cryptography.X509Certificates;
using UnityEngine;
using UnityEngine.Events;

public class InteractObject : MonoBehaviour
{
    public string interactiontext;
    public string requiredItemId = "keycard";
    public GameObject player;
    public UnityEvent onInteract;
    public PlayerInventory inventory;

    void Start()
    {
        if (player == null)
        {
            player = GameObject.FindGameObjectWithTag("Player");
        }

        if (player != null)
        {
            inventory = player.GetComponent<PlayerInventory>();
        }
    }

    public string GetInteractionText()
    {
        return interactiontext;
    }

    public void OnInteract()
    {

    }
}
