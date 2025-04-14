using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SwitchController : MonoBehaviour
{
    public GameObject originalObject;
    public GameObject toggle;
    public GameObject targetObject;
    private bool isOn = false;
    private Animator animator;
    // public Switch switch1;
    // public Switch switch2;
    // public Switch switch3;
    //List<Switch> combination = new List<Switch>();

    // Correct Switch Combination: 3, 1, 2
    void Start()
    {
        animator = GetComponent<Animator>();
    }

    // Update is called once per frame
    //public void correctCombo(Switch switch1, Switch switch2, Switch switch3)
    //{
    //combination[0] = switch3;
    //combination[1] = switch1;
    //combination[2] = switch2;
    //}

    //Primarily for the animations to play and flip the switch on and off
    public void ToggleSwitch()
    {
        if (isOn == false)
        {
            isOn = true;
            animator.SetBool("isOn", true);
            Debug.Log("Switch Flipped On");
        }
        else if (isOn == true)
        {
            isOn = false;
            animator.SetBool("isOn", false);
            Debug.Log("Switch Flipped Off");
        }


    }
}