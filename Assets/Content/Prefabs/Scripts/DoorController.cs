using System;
using NUnit.Framework;
using Unity.VisualScripting;
using UnityEngine;

public class DoorController : MonoBehaviour
{
    public string KeycardID;
    private bool isOpen = false;
    private Animator animator;
    void Start()
    {
        animator = GetComponent<Animator>();
        animator.SetBool("isOpen", false);
    }

    public void OpenAndClose()
    {
        if (isOpen == false)
        {
            isOpen = true;
            animator.SetBool("isOpen", true);
            Debug.Log("Door Opened");
        }
        else if (isOpen == true)
        {
            isOpen = false;
            animator.SetBool("isOpen", false);
            Debug.Log("Door Closed");
        }
    }
}
