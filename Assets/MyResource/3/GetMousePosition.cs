using UnityEngine;

[ExecuteInEditMode]
public class GetMousePosition : MonoBehaviour
{
    [SerializeField] private Material material;
    private void Update()
    {
        material.SetVector("_MousePos", Input.mousePosition);
    }
}
