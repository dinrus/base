﻿module col.Link;

private import col.DefaultAllocator;

/+ ИНТЕРФЕЙС:


struct Связка(З)
{
    alias Связка *Узел;
    Узел следщ;
    Узел предш;
    З значение;
    Узел надставь(Узел n);
    Узел подставь(Узел n);
    Узел открепи();
    static проц крепи(Узел первый, Узел второй);
    бцел счёт(Узел концУзел = пусто);
    Узел dup(Узел delegate(З з) функцияСоздать);
    Узел dup();
}

struct ГоловаСвязки(З, alias Разместитель=ДефолтныйРазместитель)
{

    alias Связка!(З).Узел Узел;
    alias Разместитель!(Связка!(З)) разместитель;
    разместитель разм;
    Узел конец;
    бцел счёт;
    Узел начало();
    проц установка();
    Узел удали(Узел n);
    проц сортируй(Сравниватель)(Сравниватель comp);
    Узел удали(Узел первый, Узел последн);
    Узел вставь(Узел перед, З з);
    проц зачисть();
    проц копируйВ(ref ГоловаСвязки цель, бул копироватьУзлы=true);
    private Узел размести();
    private Узел размести(З з);
}

+/

/**
 * Узел линкованного списка, использующийся в различных классах коллекций.
 */
struct Связка(З)
{
    /**
     * Удобный псевдоним.s
     */
    alias Связка *Узел;
    Узел следщ;
    Узел предш;

    /**
     * Значение, которое представлено данным линкованным Узел.
     */
    З значение;

    /**
     * Вставляет заданный Узел между этим Узлом и предыдущим. Обновляются все указатели 
     * на this, n и предш.
     *
     * Возвращает this, с которым возможно сцепление.
     */
    Узел надставь(Узел n)
    {
        крепи(предш, n);
        крепи(n, this);
        return this;
    }

    /**
     * Вставляет заданный Узел между этим Узлом и следующим. Обновляются все указатели 
     * на this, n и следщ.
     *
     * Возвращает this, с которым возможно сцепление.
     */
    Узел подставь(Узел n)
    {
        крепи(n, следщ);
        крепи(this, n);
        return this;
    }

    /**
     * Удаляет этот Узел из этого списка. Если предш или следщ равны не-пусто, их
     * указатели обновляются.
     *
     * Возвращает this, с которым возможно сцепление.
     */
    Узел открепи()
    {
        крепи(предш, следщ);
        следщ = предш = пусто;
        return this;
    }

    /**
     * Линкует два узла вместе.
     */
    static проц крепи(Узел первый, Узел второй)
    {
        if(первый)
            первый.следщ = второй;
        if(второй)
            второй.предш = первый;
    }

    /**
     * Вычмсляет, сколько узлов до концУзел.
     */
    бцел счёт(Узел концУзел = пусто)
    {
        Узел x = this;
        бцел c = 0;
        while(x !is концУзел)
        {
            x = x.следщ;
            c++;
        }
        return c;
    }

    Узел dup(Узел delegate(З з) функцияСоздать)
    {
        //
        // создаёт дубликат этого и всех узлов после этого.
        //
        auto n = следщ;
        auto возврзнач = функцияСоздать(значение);
        auto тек = возврзнач;
        while(n !is пусто && n !is this)
        {
            auto x = функцияСоздать(n.значение);
            крепи(тек, x);
            тек = x;
            n = n.следщ;
        }
        if(n is this)
        {
            //
            // циркулярный список, заполняет круг
            //
            крепи(тек, возврзнач);
        }
        return возврзнач;
    }

    Узел dup()
    {
        Узел _создай(З з)
        {
            auto n = new Связка!(З);
            n.значение = з;
            return n;
        }
        return dup(&_создай);
    }
}

/**
 * Эта структура использует Связка(З), чтобы отслеживать значения линкованного списка.
 *
 * Эта реализация использует dummy link узел, который одновременно является головой и хвостом
 * списка.  Как правило, этот список круговой, с dummy узел, отмечающим
 * конец/начало.
 */
struct ГоловаСвязки(З, alias Разместитель=ДефолтныйРазместитель)
{
    /**
     * Удобный псевдоним.
     */
    alias Связка!(З).Узел Узел;

    /**
     * Удобный псевдоним.
     */
    alias Разместитель!(Связка!(З)) разместитель;

    /**
     * Разместитель для головы.
     */
    разместитель разм;

    /**
     * Узел, отмечающий конец списка.
     */
    Узел конец; //невалидный узел

    /**
     * Число узлов в этом списке.
     */
    бцел счёт;

    /**
     * Получить первый валидный узел в этом списке.
     */
    Узел начало()
    {
        return конец.следщ;
    }

    /**
     * Инициализует список.
     */
    проц установка()
    {
        //конец = new Узел;
        конец = размести();
        Узел.крепи(конец, конец);
        счёт = 0;
    }

    /**
     * Удаляет узел из этого списка, возвращая следщ узел в списке, или
     * конец, если этот узел был последним в списке. Операция O(1).
     */
    Узел удали(Узел n)
    {
        счёт--;
        Узел возврзнач = n.следщ;
        n.открепи;
        static if(разместитель.нужноСвоб)
            разм.освободи(n);
        return возврзнач;
    }

    /**
     * Сортирует список, согласно заданной функции сравнения.
     */
    проц сортируй(Сравниватель)(Сравниватель comp)
    {
        if(конец.следщ.следщ is конец)
            //
            // нет узлов для сортировки
            //
            return;

        //
        // detach the sentinel
        //
        конец.предш.следщ = пусто;

        //
        // использовать совмести сортировку, не обновляем предш указатели, пока сортировка
        // не закончится.
        //
        цел К = 1;
        while(К < счёт)
        {
            //
            // конец.следщ служит как голова сортированного списка
            //
            Узел голова = конец.следщ;
            конец.следщ = пусто;
            Узел сортированныйхвост = конец;
            цел врмсчёт = счёт;

            while(голова !is пусто)
            {

                if(врмсчёт <= К)
                {
                    //
                    // остаток уже отсортирован
                    //
                    сортированныйхвост.следщ = голова;
                    break;
                }
                Узел лево = голова;
                for(цел к = 1; к < К && голова.следщ !is пусто; к++)
                    голова = голова.следщ;
                Узел право = голова.следщ;

                //
                // голова теперь указывает на последн элемент в 'лево', открепим
                // левую сторону
                //
                голова.следщ = пусто;
                цел члоправ = К;
                while(true)
                {
                    if(лево is пусто)
                    {
                        сортированныйхвост.следщ = право;
                        while(члоправ != 0 && сортированныйхвост.следщ !is пусто)
                        {
                            сортированныйхвост = сортированныйхвост.следщ;
                            члоправ--;
                        }
                        голова = сортированныйхвост.следщ;
                        сортированныйхвост.следщ = пусто;
                        break;
                    }
                    else if(право is пусто || члоправ == 0)
                    {
                        сортированныйхвост.следщ = лево;
                        сортированныйхвост = голова;
                        голова = право;
                        сортированныйхвост.следщ = пусто;
                        break;
                    }
                    else
                    {
                        цел r = comp(лево.значение, право.значение);
                        if(r > 0)
                        {
                            сортированныйхвост.следщ = право;
                            право = право.следщ;
                            члоправ--;
                        }
                        else
                        {
                            сортированныйхвост.следщ = лево;
                            лево = лево.следщ;
                        }
                        сортированныйхвост = сортированныйхвост.следщ;
                    }
                }

                врмсчёт -= 2 * К;
            }

            К *= 2;
        }

        //
        // теперь крепим все предш узлы
        //
        Узел n;
        for(n = конец; n.следщ !is пусто; n = n.следщ)
            n.следщ.предш = n;
        Узел.крепи(n, конец);
    }

    /**
     * Удаляет все узлы от первого до последнего. Это операция O(n).
     */
    Узел удали(Узел первый, Узел последн)
    {
        Узел.крепи(первый.предш, последн);
        auto n = первый;
        while(n !is последн)
        {
            auto nx = n.следщ;
            static if(разм.нужноСвоб)
                разм.освободи(n);
            счёт--;
            n = nx;
        }
        return последн;
    }

    /**
     * Вставляет данное значение перед заданным Узлом.  Используйте вставь(конец, з), чтобы
     * добавить в конец списка, или в пустой список. Операция O(1).
     */
    Узел вставь(Узел перед, З з)
    {
        счёт++;
        //возвращает перед.надставь(new Узел(з)).предш;
        return перед.надставь(размести(з)).предш;
    }

    /**
     * Удаляет все узлы из этого списка.
     */
    проц зачисть()
    {
        Узел.крепи(конец, конец);
        счёт = 0;
    }

    /**
     * Копирует этот список в цель.
     */
    проц копируйВ(ref ГоловаСвязки цель, бул копироватьУзлы=true)
    {
        цель = *this;
        //
        // переустановить разместитель
        //
        цель.разм = цель.разм.init;

        if(копироватьУзлы)
        {
            цель.конец = конец.dup(&цель.размести);
        }
        else
        {
            //
            // установить цель как эту
            //
            цель.установка();
        }
    }

    /**
     * Размещает новый Узел.
     */
    private Узел размести()
    {
        return разм.размести();
    }

    /**
     * Размещает новый Узел, затем устанавливает значение в з.
     */
    private Узел размести(З з)
    {
        auto возврзнач = размести();
        возврзнач.значение = з;
        return возврзнач;
    }
}
