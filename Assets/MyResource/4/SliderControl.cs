using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SliderControl : MonoBehaviour
{
    private List<Material> materials = new List<Material>();
    private Sequence sequence;
    [SerializeField, Header("单个旋转总时长")] private float time_rot = 2f;
    [SerializeField, Header("淡出纯色")] private Color solidColorOut;
    [SerializeField, Header("淡入纯色")] private Color solidColorIn;
    [SerializeField] private float stayTime = 2f;
    void Start()
    {
        for (int i = 0; i < transform.childCount; i++)
        {
            transform.GetChild(i).GetComponent<Image>().material = new Material(transform.GetChild(i).GetComponent<Image>().material);
            materials.Add(transform.GetChild(i).GetComponent<Image>().material);
            materials[i].SetFloat("_OffsetX", transform.GetChild(i).GetComponent<RectTransform>().localPosition.x - transform.GetChild(i).GetComponent<RectTransform>().sizeDelta.x / 2f);
            materials[i].SetFloat("_UVOffset", materials[i].GetFloat("_UVScale") * (transform.GetChild(i).GetComponent<RectTransform>().localPosition.x - transform.GetChild(0).GetComponent<RectTransform>().localPosition.x) / transform.GetChild(0).GetComponent<RectTransform>().sizeDelta.x);
        }

        sequence = DOTween.Sequence().SetUpdate(true).SetId(transform);
        for (int i = 0; i < transform.childCount; i++)
        {
            sequence.Insert(time_rot / transform.childCount * i, materials[i].DOFloat(90f, "_Rotation", time_rot))
            .Insert(time_rot / transform.childCount * i, materials[i].DOColor(solidColorOut, "_SolidColor", 0))
            .Insert(time_rot / transform.childCount * i, materials[i].DOFloat(1f, "_BlendAmount", time_rot))

            .Insert(time_rot / transform.childCount * i + time_rot + stayTime, materials[i].DOColor(solidColorIn, "_SolidColor", 0))
            .Insert(time_rot / transform.childCount * i + time_rot + stayTime * 2, materials[i].DOFloat(0, "_Rotation", time_rot))
            .Insert(time_rot / transform.childCount * i + 0.5f + stayTime * 2 + time_rot, materials[i].DOFloat(0, "_BlendAmount", 0.5f));
        }
        sequence.AppendInterval(stayTime).SetLoops(-1);
        
    }

    private void OnDestroy()
    {
        DOTween.Kill(transform);
    }
}
