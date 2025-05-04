using UnityEngine;

namespace KeySystem
{
  public class KeyItemController : MonoBehaviour
  {
    [Header("Key Pickup Settings")]
    [SerializeField] private bool isKeyItem = false;
    [SerializeField] private string keyName = "RedKey";
    [SerializeField] private KeyInventory _keyInventory = null;

    [Header("Door Control (If this is a Door)")]
    [SerializeField] private bool isDoor = false;
    [SerializeField] private KeyDoorController doorController;

    public void ObjectInteraction()
    {
      if (isKeyItem && _keyInventory != null)
      {
        _keyInventory.AddKey(keyName);
        Debug.Log($"🔑 Collected key: {keyName}");
        gameObject.SetActive(false);
      }
      else if (isDoor && doorController != null)
      {
        doorController.PlayAnimation();
      }
    }
  }
}
