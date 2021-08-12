module io.stream.Delimiters;

private import io.stream.Iterator;

class Разграничители(T) : Обходчик!(T)
{
        private T[] разделитель;

        this (T[] разделитель, ИПотокВвода поток = пусто)
        {
                this.разделитель = разделитель;
                super (поток);
        }

protected т_мера скан(проц[] дан)
        {
                auto контент = (cast(T*) дан.ptr) [0 .. дан.length / T.sizeof];

                if (разделитель.length is 1)
                   {
                   foreach (цел i, T c; контент)
                            if (c is разделитель[0])
                                return найдено (установи (контент.ptr, 0, i, i));
                   }
                else
                   foreach (цел i, T c; контент)
                            if (есть (разделитель, c))
                                return найдено (установи (контент.ptr, 0, i, i));

                return неНайдено;
        }
}


