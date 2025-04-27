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

    [SerializeField] private int timeToShowUI = 1;
    [SerializeField] private GameObject showDoorLockedUI = null;
    [SerializeField] private KeyInventory _keyInventory = null;
    [SerializeField] private int waitTimer = 1;
    [SerializeField] private bool pauseInteraction = false;

    [Header("Slide Settings")]
    [SerializeField] private float slideZOffset = 2f;
    [SerializeField] private float slideSpeed = 2f;

    private Vector3 closedPosition;

    private void Awake()
    {
      doorAnim = GetComponent<Animator>();
      closedPosition = transform.position;
    }

    private IEnumerator PauseDoorInteraction()
    {
      pauseInteraction = true;
      yield return new WaitForSeconds(waitTimer);
      pauseInteraction = false;
    }

    public void PlayAnimation()
    {
      if (_keyInventory.hasRedKey)
      {
        OpenDoor();
      }
      else
      {
        StartCoroutine(ShowDoorLocked());
      }
    }

    void OpenDoor()
    {
      if (!doorOpen && !pauseInteraction)
      {
        doorAnim.Play(openAnimationName, 0, 0.0f);

        Vector3 openPosition = closedPosition + new Vector3(0, 0, slideZOffset);
        StartCoroutine(SlideDoor(openPosition));

        doorOpen = true;
        StartCoroutine(PauseDoorInteraction());
      }
      else if (doorOpen && !pauseInteraction)
      {
        doorAnim.Play(closeAnimationName, 0, 0.0f);
        StartCoroutine(SlideDoor(closedPosition));

        doorOpen = false;
        StartCoroutine(PauseDoorInteraction());
      }
    }

    IEnumerator SlideDoor(Vector3 targetPosition)
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

    IEnumerator ShowDoorLocked()
    {
      if (showDoorLockedUI != null)
      {
        showDoorLockedUI.SetActive(true);
        yield return new WaitForSeconds(timeToShowUI);
        showDoorLockedUI.SetActive(false);
      }
    }
  }
}
