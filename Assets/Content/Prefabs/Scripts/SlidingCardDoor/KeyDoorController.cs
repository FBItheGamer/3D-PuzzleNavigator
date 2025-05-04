using System.Collections;
using UnityEngine;

namespace KeySystem
{
  public class KeyDoorController : MonoBehaviour
  {
    private Animator doorAnim;
    private bool doorOpen = false;

    [Header("Animation Names")]
    [SerializeField] private string openAnimationName = "DoorOpen";
    [SerializeField] private string closeAnimationName = "DoorClose";

    [Header("Key Settings")]
    [SerializeField] private string requiredKey = "RedKey";
    [SerializeField] private KeyInventory _keyInventory = null;

    [Header("UI & Delay")]
    [SerializeField] private int timeToShowUI = 1;
    [SerializeField] private GameObject showDoorLockedUI = null;
    [SerializeField] private int waitTimer = 1;

    [Header("Slide Settings")]
    [SerializeField] private Vector3 slideOffset = new Vector3(0f, 0f, 2f); // choose direction here
    [SerializeField] private float slideSpeed = 2f;

    private bool pauseInteraction = false;
    private Vector3 closedPosition;

    private void Awake()
    {
      doorAnim = GetComponent<Animator>();
      closedPosition = transform.position;
    }

    public void PlayAnimation()
    {
      if (_keyInventory != null && _keyInventory.HasKey(requiredKey))
      {
        OpenDoor();
      }
      else
      {
        StartCoroutine(ShowDoorLocked());
      }
    }

    private void OpenDoor()
    {
      if (!pauseInteraction)
      {
        pauseInteraction = true;

        if (!doorOpen)
        {
          doorAnim.Play(openAnimationName);
          Vector3 openPos = closedPosition + slideOffset;
          StartCoroutine(SlideDoor(openPos));
          doorOpen = true;
        }
        else
        {
          doorAnim.Play(closeAnimationName);
          StartCoroutine(SlideDoor(closedPosition));
          doorOpen = false;
        }

        StartCoroutine(PauseDoorInteraction());
      }
    }

    private IEnumerator SlideDoor(Vector3 targetPosition)
    {
      Vector3 startPos = transform.position;
      float elapsed = 0f;

      while (elapsed < 1f)
      {
        transform.position = Vector3.Lerp(startPos, targetPosition, elapsed);
        elapsed += Time.deltaTime * slideSpeed;
        yield return null;
      }

      transform.position = targetPosition;
    }

    private IEnumerator ShowDoorLocked()
    {
      if (showDoorLockedUI != null)
      {
        showDoorLockedUI.SetActive(true);
        yield return new WaitForSeconds(timeToShowUI);
        showDoorLockedUI.SetActive(false);
      }
    }

    private IEnumerator PauseDoorInteraction()
    {
      yield return new WaitForSeconds(waitTimer);
      pauseInteraction = false;
    }
  }
}
