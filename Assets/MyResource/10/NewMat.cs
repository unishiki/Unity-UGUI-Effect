using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class NewMat : MonoBehaviour
{
    private const float BEGIN_POS = -1.6f;
    private const float END_POS = 1.6f;
    private const float L_POS = -1.3f;
    private const float R_POS = 1.3f;
    private Material _mat;
    private Tween tween_enter;
    private Tween tween_exit;
    private Tween tween_down;
    private bool inBtn;
    private bool inAnim;
    void Start()
    {
        _mat = Instantiate(GetComponent<Image>().material);
        GetComponent<Image>().material = _mat;
        _mat = GetComponent<Image>().material;
        _mat.SetFloat("_SunPos", BEGIN_POS);
        inBtn = false;
        inAnim = false;
    }

    public void OnMouseEnter()
    {
        if (!inBtn)
        {
            if (inAnim) return;

            inBtn = true;

            tween_enter?.Kill();

            if (_mat.GetFloat("_SunPos") < 0)
            {
                tween_enter = DOTween.To((value) =>
                {
                    _mat.SetFloat("_SunPos", value);
                }, _mat.GetFloat("_SunPos"), L_POS, 0.3f);
            }
            else
            {
                tween_enter = DOTween.To((value) =>
                {
                    _mat.SetFloat("_SunPos", value);
                }, _mat.GetFloat("_SunPos"), R_POS, 0.3f);
            }
        }
        
        
    }
    public void OnMouseExit()
    {
        if (inBtn)
        {
            if (inAnim) return;

            inBtn = false;

            tween_exit?.Kill();

            if (_mat.GetFloat("_SunPos") < 0)
            {
                tween_exit = DOTween.To((value) =>
                {
                    _mat.SetFloat("_SunPos", value);
                }, _mat.GetFloat("_SunPos"), BEGIN_POS, 0.3f);
            }
            else
            {
                tween_exit = DOTween.To((value) =>
                {
                    _mat.SetFloat("_SunPos", value);
                }, _mat.GetFloat("_SunPos"), END_POS, 0.3f);
            }
        }
    }
    public void OnMouseDown()
    {
        if (inAnim) return;
        inAnim = true;
        tween_down?.Kill();

        if (_mat.GetFloat("_SunPos") < 0)
        {
            tween_down = DOTween.To((value) =>
            {
                _mat.SetFloat("_SunPos", value);
            }, _mat.GetFloat("_SunPos"), END_POS, 1f).OnComplete(()=> { inAnim = false; inBtn = false; });
        }
        else
        {
            tween_down = DOTween.To((value) =>
            {
                _mat.SetFloat("_SunPos", value);
            }, _mat.GetFloat("_SunPos"), BEGIN_POS, 1f).OnComplete(() => { inAnim = false; inBtn = false; });
        }
    }
}
