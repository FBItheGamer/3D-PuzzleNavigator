using System;
using Unity.VisualScripting;
using UnityEngine;

public class DoorController : MonoBehaviour
{
    public GameObject Door;
    public GameObject OpenDoor;
    public GameObject Keycard;
    public String ItemID = "keycard";
    private PlayerInventory inventory;
    private bool isOpen = false;

    void Start()
    {
        if (Door != null && OpenDoor != null)
        {
            Door.SetActive(!isOpen);
            OpenDoor.SetActive(isOpen);
        }
    }

    public void Open(String ItemID)
    {
        // Keycard needs to be within the inventory and looked for
        if (Door != null && OpenDoor != null)
        {
            if (inventory.HasItem(ItemID))
            {
                Door.SetActive(isOpen);
                OpenDoor.SetActive(!isOpen);
            }


        }
    }

    public void Close()
    {
        // Keycard needs to be within the inventory and need to check for it
        if (Door != null && OpenDoor != null)
        {
            Door.SetActive(!isOpen);
            OpenDoor.SetActive(isOpen);
        }
    }
}
