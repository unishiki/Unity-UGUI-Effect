using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class Btn2Control : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    private Material mat;
    [SerializeField] private float speed = .3f;
    private float offsetValue;
    private bool flag;

    private void Start()
    {
        GetComponent<Image>().material = new Material(GetComponent<Image>().material);
        mat = GetComponent<Image>().material;
        offsetValue = 0;
        flag = false;
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        flag = true;
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        flag = false;
    }

    private void Update()
    {
        if (flag)
            offsetValue += Time.deltaTime * speed;
        mat.SetFloat("_OffsetX", offsetValue);
    }
}
