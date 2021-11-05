﻿module text.locale.Collation;

private import text.locale.Core;

/**
Сравнивает строки, используя указанные регистр и правила сравнения для культуры.
*/
public class СтрокоСопоставитель
{

    private static СтрокоСопоставитель инвариант_;
    private static СтрокоСопоставитель инвариантИгнорРег_;
    private Культура культура_;
    private бул игнорРег_;

    static this()
    {
        инвариант_ = new СтрокоСопоставитель(Культура.инвариантнаяКультура, нет);
        инвариантИгнорРег_ = new СтрокоСопоставитель(Культура.инвариантнаяКультура, да);
    }

    public this(Культура культура, бул ignoreCase) ;

    public цел сравни(ткст тктА, ткст тктБ);

    public бул равно(ткст тктА, ткст тктБ) ;

    public static СтрокоСопоставитель текущаяКультура();

    public static СтрокоСопоставитель текущаяКультураИгнорРег() ;

    public static СтрокоСопоставитель инвариантнаяКультура() ;

    public static СтрокоСопоставитель инвариантнаяКультураИгнорРег() ;

}

/**
  $(I Delegate.) Represents the метод that will укз the ткст сравнение.
  Remarks:
    The delegate имеется the сигнатура $(I цел delegate(ткст, ткст)).
 */
alias цел delegate(ткст, ткст) СравнениеСтрок;

/**
  Сортирует строки в соответствии с правилами означенной культуры.
 */
public class СтрокоСортировщик
{

    private static СтрокоСортировщик инвариант_;
    private static СтрокоСортировщик инвариантИгнорРег_;
    private Культура культура_;
    private СравнениеСтрок сравнение_;

    static this()
    {
        инвариант_ = new СтрокоСортировщик(СтрокоСопоставитель.инвариантнаяКультура);
        инвариантИгнорРег_ = new СтрокоСортировщик(СтрокоСопоставитель.инвариантнаяКультураИгнорРег);
    }


    public this(СтрокоСопоставитель сравниватель = пусто);

    public this(СравнениеСтрок сравнение);

    public проц сортируй(ref ткст[] массив);

    public проц сортируй(ref ткст[] массив, цел индекс, цел счёт) ;

    public static СтрокоСортировщик текущаяКультура() ;

    public static СтрокоСортировщик текущаяКультураИгнорРег() ;

    public static СтрокоСортировщик инвариантнаяКультура() ;

    public static СтрокоСортировщик инвариантнаяКультураИгнорРег() ;

}
