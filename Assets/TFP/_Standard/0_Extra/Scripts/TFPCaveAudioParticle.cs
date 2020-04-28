using UnityEngine;
using UnityEngine.Audio;
using System.Collections;
public class TFPCaveAudioParticle : MonoBehaviour
{
	public float audioTransitionDuration = 0.6f;
	public AudioMixerSnapshot open;
	public AudioMixerSnapshot cave;
	public ParticleSystem rain;

	public float ambienceTransitionDuration = 1f;
	public float caveAmbientIntensity;
	public float outdoorAmbientIntensity;

	void OnTriggerEnter (Collider other)
	{
		if (other.gameObject.tag == "CaveTrigger")
		{
			// Transitions audio.
			cave.TransitionTo (.6f);

			// Transitions ambient intensity to cave intensity.
			InitAmbienceTransition (caveAmbientIntensity, ambienceTransitionDuration);

			rain.Stop ();

		}
	}
	void OnTriggerExit (Collider other)
	{
		if (other.gameObject.tag == "CaveTrigger")
		{
			// Transitions audio.
			open.TransitionTo (.6f);

			// Transitions ambient intensity to outdoor intensity.
			InitAmbienceTransition (outdoorAmbientIntensity, ambienceTransitionDuration);

			rain.Play ();

		}
	}

	public void InitAmbienceTransition (float goalAmbience, float duration)
	{
		StartCoroutine (ChangeAmbience (goalAmbience, duration));
	}

	private System.Collections.IEnumerator ChangeAmbience (float goalAmbience, float duration)
	{
		float
		startAmbience = RenderSettings.ambientIntensity,
		progress = 0f;

		while (progress < 1f)
		{
			progress = Mathf.Clamp01 (progress + Time.deltaTime / duration);
			RenderSettings.ambientIntensity = Mathf.Lerp (startAmbience, goalAmbience, progress);

			yield return null;
		}
	}
}