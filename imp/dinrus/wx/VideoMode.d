module wx.VideoMode;
public import wx.common;

extern(D) struct ВидеоРежим
{
    public static ВидеоРежим opCall(цел ширь, цел высь, цел глубь, цел частота);
    public бул совпадаетС(ВидеоРежим другой);
    public цел ширь();
    public цел высь();
    public цел глубь();
    public цел частотаОбновленияВГц();
    public ткст вТкст();
}
