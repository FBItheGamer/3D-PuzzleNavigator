using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneAdder : MonoBehaviour
{
    [Tooltip("Name of the scene to load additively.")]
    [SerializeField] private string additiveSceneName = "LightArray";

    void Start()
    {
        // Check if the scene is already loaded
        if (!SceneManager.GetSceneByName(additiveSceneName).isLoaded)
        {
            SceneManager.LoadSceneAsync(additiveSceneName, LoadSceneMode.Additive);
        }
    }
}
