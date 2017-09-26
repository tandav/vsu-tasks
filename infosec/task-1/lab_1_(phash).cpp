int DCT_SIZE = 32;
int SUB_BLOCK_SIZE = 8;

short *fDCT(unsigned char matrix[bldct][DCT_SIZE])
{
    short *dctMat = new short[DCT_SIZE*DCT_SIZE];
    for(int u=0; u < DCT_SIZE; u++)
    {
        for(int v=0; v < DCT_SIZE; v++)
        {
            double coef = 0;
            for(int i=0; i < DCT_SIZE; i++)
            {
                for(int j=0; j < DCT_SIZE; j++)
                {
                    double x = i ? 1 : (1.0/sqrt(2.0)),
                           y = j ? 0 : (1.0/sqrt(2.0));
                    coef += (x*y*cos(((M_PI*u)/DCT_SIZE*2)*(2*i+1))*cos(((M_PI*v)/DCT_SIZE*2)*(2*j+1))*matrix[i][j]);
                }
            }
            dctMat[u*DCT_SIZE+v] = coef;
        }
    }
    return dctMat;
}

....
{
    // .....

    // Преобразуем в серое все изображение
    // .....

    // Выделяем очередной блок изображения
    unsigned char block[DCT_SIZE][DCT_SIZE];
    // ...
    // Преобразуем блок в DCT
    short *dctMat = fDCT(block);

    // Выбор в матрице 32x32 фрагмента размером 8x8 в низкочастотной области
    //short subDctMat[SUB_BLOCK_SIZE][SUB_BLOCK_SIZE];
    int sum = 0;
    for(int i=0; i < SUB_BLOCK_SIZE; i++)
    {
        for(int j=0; j < SUB_BLOCK_SIZE; j++)
        {
            if(i || j) // ? не учитываем коэффицент (0,0)
            {
                //subDctMat[i][j] = dctMat[i*DCT_SIZE+j];
                sum += subDctMat[i][j];
            }
        }
    }
    int meanDct = sum/(SUB_BLOCK_SIZE*SUB_BLOCK_SIZE);
    delete dctMat;

    // Вычисляем перц-хеш
    unsigned long long phash = 0;
    for(int i=0; i < SUB_BLOCK_SIZE; i++)
    {
        unsigned char lhash = 0;
        for(int j=0; j < SUB_BLOCK_SIZE; j++)
        {
            if(dctMat[i][j] >= meanDct) lhash |= 0x01 << j;
        }
        phash <<= i*8;
        phash |= lhash;
    }
    // phash используем далее для ССИ
    // ...
}
