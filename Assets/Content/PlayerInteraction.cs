using UnityEngine;
using TMPro;

public class PlayerInteraction : MonoBehaviour
{
    public Camera PlayerCamera;
    public float InteractionDistance = 3f;
    public GameObject InteractionText;
    private InteractObject currentInteractable;
    // Update is called once per frame
    void Update()
    {
        Ray beam = Camera.main.ScreenPointToRay(new Vector3(Screen.width / 2, Screen.height / 2, 0));
        RaycastHit hit;

        if (Physics.Raycast(beam, out hit, InteractionDistance))
        {

            InteractObject interactableObject = hit.collider.GetComponent<InteractObject>();
            if (interactableObject != null && interactableObject != currentInteractable)
            {
                currentInteractable = interactableObject;

                InteractionText.SetActive(true);

                TextMeshProUGUI textComponent = InteractionText.GetComponent<TextMeshProUGUI>();

                if (textComponent != null)
                {
                    textComponent.text = currentInteractable.GetInteractionText();
                }

            }
        }

        else
        {
            currentInteractable = null;
            InteractionText.SetActive(false);
        }

        if (Input.GetKeyDown(KeyCode.E))
        {
            currentInteractable.OnInteract();
        }

    }
}
