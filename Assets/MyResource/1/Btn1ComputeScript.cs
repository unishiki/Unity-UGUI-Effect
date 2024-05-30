using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using DG.Tweening;
using UnityEngine.EventSystems;
using UnityEngine.UI;
public class Btn1ComputeScript : MonoBehaviour
{
    [SerializeField] private Material material;
    [SerializeField] private List<Material> materials = new List<Material>(3);
    [ColorUsageAttribute(true, true), SerializeField, Header("文字颜色")]
    private List<Color> textColor_In = new List<Color>();
    [ColorUsageAttribute(true, true), SerializeField, Header("文字颜色")]
    private Color textColor_Out;
    private List<bool> _isOverBtn = new List<bool>() { false, false, false};
    [SerializeField] private List<GameObject> btns = new List<GameObject>(3);
    private List<TextMeshProUGUI> _text = new List<TextMeshProUGUI>(3);

    private void Start()
    {
        for (int i = 0; i < _isOverBtn.Count; i++)
        {
            _isOverBtn[i] = false;
            _text.Add(btns[i].transform.GetChild(0).GetComponent<TextMeshProUGUI>());

            btns[i].GetComponent<Image>().material = new Material(material);
            materials.Add(btns[i].GetComponent<Image>().material);
            materials[i].SetColor("_Color", textColor_In[i]);
        }
        
    }
    private void Update()
    {
        for (int i = 0; i < materials.Count; i++)
        {
            materials[i].SetVector("_MousePos", Input.mousePosition);
        }
        if (IsPointerOverBtnUI() != -1 && !_isOverBtn[IsPointerOverBtnUI()])
        {
            _isOverBtn[IsPointerOverBtnUI()] = true;
            Sequence textLightSq = DOTween.Sequence().SetUpdate(true).SetId(transform);
            textLightSq.Append(_text[IsPointerOverBtnUI()].DOColor(textColor_In[IsPointerOverBtnUI()], .6f))
            .Join(DOTween.To((v) =>
            {
                _text[IsPointerOverBtnUI()].outlineWidth = v;
            }, 0, 0.01f, .6f) );
            

        }
        if (IsPointerOverBtnUI() == -1 && (_isOverBtn[0] || _isOverBtn[1] || _isOverBtn[2]))
        {
            Sequence textLightSq = DOTween.Sequence().SetUpdate(true).SetId(transform);
            if (_isOverBtn[0])
            {
                textLightSq.Append(_text[0].DOColor(textColor_Out, .6f))
                .Join(DOTween.To((v) =>
                {
                    _text[0].outlineWidth = v;
                }, 0.01f, 0, .6f));
            }
            else if (_isOverBtn[1])
            {
                textLightSq.Append(_text[1].DOColor(textColor_Out, .6f))
                .Join(DOTween.To((v) =>
                {
                    _text[1].outlineWidth = v;
                }, 0.01f, 0, .6f));
            }
            else if (_isOverBtn[2])
            {
                textLightSq.Append(_text[2].DOColor(textColor_Out, .6f))
                .Join(DOTween.To((v) =>
                {
                    _text[2].outlineWidth = v;
                }, 0.01f, 0, .6f));
            }


            for (int i = 0; i < _isOverBtn.Count; i++)
            {
                _isOverBtn[i] = false;
            }
        }
    }
    // return BtnIndex (0, 1, 2) or -1
    private int IsPointerOverBtnUI()
    {
        PointerEventData eventData = new PointerEventData(EventSystem.current);
        eventData.position = Input.mousePosition;

        List<RaycastResult> results = new List<RaycastResult>();
        EventSystem.current.RaycastAll(eventData, results);
        for (int i = 0; i < results.Count; i++)
        {
            if (results[i].gameObject.name.Contains("Button_0"))
            {
                return 0;
            }
            else if (results[i].gameObject.name.Contains("Button_1"))
            {
                return 1;
            }
            else if (results[i].gameObject.name.Contains("Button_2"))
            {
                return 2;
            }
        }
        return -1;
    }

    private void OnDestroy()
    {
        DOTween.Kill(transform);
    }
}
