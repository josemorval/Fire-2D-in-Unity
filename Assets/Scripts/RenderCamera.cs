using UnityEngine;
using System.Collections;

public class RenderCamera : MonoBehaviour {

	public Material mat;
	public Camera firstCamera;
	RenderTexture rt;

	void Start () {

		rt = new RenderTexture(Screen.width,Screen.height,0);
		firstCamera.targetTexture = rt;
	
	}
	
	void OnRenderImage(RenderTexture src, RenderTexture dst){
		mat.SetTexture("_AnotherTex",rt);
		Graphics.Blit(src,dst,mat);
	}
}
