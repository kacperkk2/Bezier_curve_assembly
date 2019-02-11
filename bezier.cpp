#include <iostream>
#include <cstring>
#include <SDL2/SDL.h>

extern "C" {void drawBezier(int* mouseX,int* mouseY, Uint32* pixels);}

int main(int argc, char ** argv)
{
    int i = 0;
    bool quit = false;
    SDL_Event event;
    int mouseX[5];
    int mouseY[5];

    SDL_Init(SDL_INIT_VIDEO);

    SDL_Window * window = SDL_CreateWindow("SDL2 Pixel Drawing", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480, 0);

    SDL_Renderer * renderer = SDL_CreateRenderer(window, -1, 0);
    SDL_Texture * texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STATIC, 640, 480);
    Uint32 * pixels = new Uint32[640 * 480];
    memset(pixels, 255, 640 * 480 * sizeof(Uint32));

    while (!quit)
    {
        SDL_UpdateTexture(texture, NULL, pixels, 640 * sizeof(Uint32));
        SDL_WaitEvent(&event);

        switch (event.type)
        {
            case SDL_MOUSEBUTTONDOWN:
                if (event.button.button == SDL_BUTTON_LEFT)
                {
                    if(i > 4)
                    {
			if(argc == 2 && std::string(argv[1]) == "-nc")
				std::cout<<"Klikniecie nr "<<i + 1<<" bez wyczyszczenia tablicy"<<std::endl;
			else
			{
				std::cout<<"Klikniecie nr "<<i + 1<<" i zerowanie tablicy"<<std::endl;
		                memset(pixels, 255, 640 * 480 * sizeof(Uint32));
			}
                        i = 0;
                    }
                    else
                    {
			std::cout<<"Klikniecie nr "<<i + 1<<std::endl; 
                        mouseX[i] = event.motion.x;
                        mouseY[i] = event.motion.y;
			
                        if(i == 4) 
			{
				std::cout<<"Wywolanie funkcji rysowania"<<std::endl; 
				drawBezier(mouseX, mouseY, pixels);
				std::cout<<"Wyjscie z funkcji rysowania"<<std::endl;
			} 
                        i++;
                    }
                }
                break;
            case SDL_QUIT:
                quit = true;
                break;
        }

        SDL_RenderClear(renderer);
        SDL_RenderCopy(renderer, texture, NULL, NULL);
        SDL_RenderPresent(renderer);
    }

    delete[] pixels;
    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
