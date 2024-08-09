using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

// Shader参考：
// https://blog.csdn.net/qq_28299311/article/details/105101378
// https://www.cnblogs.com/wxiaonan/p/16556650.html
// unishiki.cc (games101、SDF、Mathematical-Visualization-01 、02)
public class ColorSelector : MonoBehaviour
{
    [Header("状态")]
    [SerializeField] private bool inHSVAnnular = false;
    [SerializeField] private bool inHSVRect = false;

    // 计算用
    private Vector2 mousePos;
    Vector2 uipos;

    [Header("HSV圆环")]
    [SerializeField] private Material mat_HSVPolarCoordinate;
    [SerializeField] private RectTransform rect_HSVPolarCoordinate;
    private const float ANNULAR_SCALE = 0.9f;

    [Header("HSV矩形")]
    [SerializeField] private Material mat_HSVRect;
    [SerializeField] private RectTransform rect_HSVRect;

    [Header("最终颜色输出")]
    [SerializeField] private float H;
    [SerializeField] private float S;
    [SerializeField] private float V;
    [SerializeField] private Image colorSelected;

    private void Start()
    {
        H = 1;
        S = 1;
        V = 1;
    }
    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            if (IsPointerOverUIObject("InHSVRect"))
            {
                inHSVRect = true;
            }
            if (IsPointerOverUIObject("InHSVAnnular"))
            {
                inHSVAnnular = true;
            }
        }
        // HSV 圆环
        if (inHSVAnnular && Input.GetMouseButton(0))
        {
            // shader上的圆环跟随鼠标表现
            RectTransformUtility.ScreenPointToLocalPointInRectangle(rect_HSVPolarCoordinate.parent as RectTransform, Input.mousePosition, Camera.main, out uipos);
            mousePos = (uipos - (Vector2)rect_HSVPolarCoordinate.localPosition) / rect_HSVPolarCoordinate.sizeDelta;
            mousePos *= 2;
            mousePos = Vector3.Normalize(mousePos) * ANNULAR_SCALE;
            mat_HSVPolarCoordinate.SetVector("_MousePos", mousePos);

            // https://blog.csdn.net/ZuoXuanZuo/article/details/122950800
            H = mousePos.y >= 0 ? Mathf.Rad2Deg * Mathf.Atan2(mousePos.y, mousePos.x) : 180 + Mathf.Rad2Deg * Mathf.Atan2(-mousePos.y, -mousePos.x); // 0 ~ 360
            H /= 360f; // 0 ~ 1


            // 计算最终颜色
            colorSelected.color = Color.HSVToRGB(H, S, V);
            // 矩形色相跟着改变
            mat_HSVRect.SetColor("_ColorSelected", Color.HSVToRGB(H, 1, 1));
        }
        // HSV 矩形
        if (inHSVRect && Input.GetMouseButton(0))
        {
            // shader上的圆环跟随鼠标表现
            RectTransformUtility.ScreenPointToLocalPointInRectangle(rect_HSVRect.parent as RectTransform, Input.mousePosition, Camera.main, out uipos);
            mousePos = (uipos - (Vector2)rect_HSVRect.localPosition) / rect_HSVRect.sizeDelta;
            mousePos *= 2;
            mousePos.x = Mathf.Clamp(mousePos.x, -1f, 1f); // -1 ~ 1
            mousePos.y = Mathf.Clamp(mousePos.y, -1f, 1f); // -1 ~ 1
            mat_HSVRect.SetVector("_MousePos", mousePos);

            S = (mousePos.x + 1) * 0.5f; 
            V = (mousePos.y + 1) * 0.5f;

            // 计算最终颜色
            colorSelected.color = Color.HSVToRGB(H, S, V);
        }

        if (Input.GetMouseButtonUp(0))
        {
            inHSVAnnular = false;
            inHSVRect = false;
        }
    }

    private bool IsPointerOverUIObject(string _name)
    {
        PointerEventData eventData = new PointerEventData(EventSystem.current);
        eventData.position = Input.mousePosition;

        List<RaycastResult> results = new List<RaycastResult>();
        EventSystem.current.RaycastAll(eventData, results);
        return results.Count > 0 ? results[0].gameObject.name.Contains(_name) : false;
    }

}
