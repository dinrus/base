module col.model.IteratorX;


/**
 *
 **/

public interface Обходчик(З)
{
        public бул ещё();

        public З получи();

        цел opApply (цел delegate (inout З значение) дг);        
}
