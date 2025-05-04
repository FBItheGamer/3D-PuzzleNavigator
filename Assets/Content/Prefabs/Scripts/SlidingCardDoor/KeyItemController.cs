using UnityEngine;

namespace KeySystem
{
  public class KeyItemController : MonoBehaviour
  {
    [SerializeField] private bool redDoor = false;
    [SerializeField] private bool redKey = false;
    [SerializeField] private bool amberDoor = false;
    [SerializeField] private bool amberKey = false;
    [SerializeField] private KeyInventory _keyInventory = null;

    private KeyDoorController doorObject;

    private void Start()
    {
      if (redDoor)
      {
        doorObject = GetComponent<KeyDoorController>();
      }
      if (amberDoor)
      {
        doorObject = GetComponent<KeyDoorController>();
      }
    }
    public void ObjectInteraction()
    {
      if (redDoor)
      {
        doorObject.PlayAnimation();
      }
      else if (redKey)
      {
        _keyInventory.hasRedKey = true;
        gameObject.SetActive(false);
      }
      if (amberDoor)
      {
        doorObject.PlayAnimation();
      }
      else if (amberKey)
      {
        _keyInventory.hasRedKey = true;
        gameObject.SetActive(false);
      }
    }
  }

}