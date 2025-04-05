using System;
using UnityEngine;
using UnityEngine.UI;

public class Switch : MonoBehaviour
{
    public GameObject originalObject;
    public GameObject toggle;
    public GameObject targetObject;
    private bool isOn = false;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        if (toggle != null)
        {
            toggle.SetActive(isOn);
        }
    }

    // Update is called once per frame

    public void ToggleSwitch(bool isOn)
    {
        isOn = true;

        toggle.SetActive(isOn);

        if (targetObject != null)
        {
            targetObject.SetActive(!isOn);
            Destroy(originalObject);
        }

    }
}
