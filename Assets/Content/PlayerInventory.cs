using System;
using System.Collections.Generic;
using UnityEditor.Search;
using UnityEngine;

public class PlayerInventory : MonoBehaviour
{
    public List<String> inventory = new List<String>();

    public void AddItem(String itemID)
    {
        if (!inventory.Contains(itemID))
        {
            inventory.Add(itemID);
        }
    }

    public void RemoveItem(String itemID)
    {
        if (inventory.Contains(itemID))
        {
            inventory.Remove(itemID);
        }
    }

    public bool HasItem(String itemID)
    {
        return inventory.Contains(itemID);
    }
}

