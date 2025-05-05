using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Video;
using UnityEngine.UI;
using System.Collections;

public class PortalTrigger : MonoBehaviour
{
    public VideoPlayer videoPlayer;
    public float delayBeforeFade = 4f; // Wait before fade
    public float fadeDuration = 2f; // Fade time
    public int sceneIndexToLoad = 3; // Scene index number
    public Image fadeImage;

    private bool triggered = false;

    private void OnTriggerEnter(Collider other)
    {
        if (!triggered && other.CompareTag("Player"))
        {
            triggered = true;
            StartCoroutine(PlayVideoAndTransition());
        }
    }

    private IEnumerator PlayVideoAndTransition()
    {
        if (videoPlayer != null)
        {
            videoPlayer.Play();
        }

        yield return new WaitForSeconds(delayBeforeFade);

        if (fadeImage != null)
        {
            yield return StartCoroutine(FadeToBlack());
        }

        SceneManager.LoadScene(sceneIndexToLoad);
    }

    private IEnumerator FadeToBlack()
    {
        float elapsed = 0f;
        Color color = fadeImage.color;

        while (elapsed < fadeDuration)
        {
            elapsed += Time.deltaTime;
            color.a = Mathf.Clamp01(elapsed / fadeDuration);
            fadeImage.color = color;
            yield return null;
        }
    }
}
