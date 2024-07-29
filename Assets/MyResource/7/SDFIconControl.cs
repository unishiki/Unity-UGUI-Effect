using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using DG.Tweening;

public class SDFIconControl : MonoBehaviour,IPointerEnterHandler,IPointerExitHandler
{
    private Material mat;
    private Sequence sequence;
    [SerializeField] private Vector2 stepFromTo = new Vector2(1.3f, 0.95f);
    [SerializeField] private Vector3 scaleFromToInit = new Vector3(8f, 4f, 6f);
    // Init
    [SerializeField, ColorUsage(true, true)] private Color ColorEdge;
    [SerializeField, ColorUsage(true, false)] private Color ColorMain;
    [SerializeField, ColorUsage(true, true)] private Color ColorMainLight;
    [SerializeField] private Texture2D mainTex;
    private void Start()
    {
        var img =  GetComponent<Image>();
        mat = new(img.material);
        img.material = mat;

        // Init
        mat.SetTexture("_MainTex", mainTex);
        mat.SetColor("_ColorEdge", ColorEdge);
        mat.SetColor("_ColorMain", ColorMain);

    }
    public void OnPointerEnter(PointerEventData eventData)
    {
        sequence?.Kill();
        sequence = DOTween.Sequence().SetUpdate(true).SetId(gameObject)
                .Append(mat.DOFloat(scaleFromToInit.x, "_MainTexScale", 0.1f))
                .Append(mat.DOFloat(scaleFromToInit.y, "_MainTexScale", 0.4f))
                .Insert(0, mat.DOFloat(stepFromTo.y, "_Step", 0.5f).SetEase(Ease.Linear))
                .AppendCallback(()=>{
                    mat.SetColor("_ColorMain", ColorMainLight);
                });
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        mat.SetColor("_ColorMain", ColorMain);
        sequence?.Kill();
        sequence = DOTween.Sequence().SetUpdate(true).SetId(gameObject)
                .Append(mat.DOFloat(stepFromTo.x, "_Step", 0.5f).SetEase(Ease.Linear))
                .Join(mat.DOFloat(scaleFromToInit.z, "_MainTexScale", 0.5f).SetEase(Ease.Linear));
    }

    private void OnDestroy()
    {
        DOTween.Kill(gameObject);
    }
}
