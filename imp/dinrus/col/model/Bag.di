module col.model.Bag;

private import  col.model.BagView,
                col.model.IteratorX,
                col.model.Dispenser;

/**
 * Bags are собериions supporting multИПle occurrences of элементы.
 * author: Doug Lea
**/

public interface Рюкзак(З) : ОбзорРюкзака!(З), Расходчик!(З)
{
        public override Рюкзак!(З) дубликат();
        public alias дубликат dup;

        public alias добавь opCatAssign;

        проц добавь (З);

        проц добавьЕсли (З);

        проц добавь (Обходчик!(З));
}


