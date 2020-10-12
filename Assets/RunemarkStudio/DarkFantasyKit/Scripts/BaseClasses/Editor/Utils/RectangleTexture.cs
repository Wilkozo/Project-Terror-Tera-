using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Runemark.Common
{
    public class Point
    {
        public int x;
        public int y;

        public Point(int x, int y)
        {
            this.x = x;
            this.y = y;
        }

        public Point()
        {
            x = 0;
            y = 0;
        }
    }


    /// <summary>
    /// This class will generate a rectangle texture.
    /// </summary>
    public class RectangleTexture
	{
		public RectOffset BorderOffset
		{ 
			get 
			{
				int border = CornerRadius + BorderThickness;
				return new RectOffset(border, border, border, border);
			}
		}

		public int Resolution = 512;
		public Point AspectRatio = new Point(1, 1); 

		public Color FillColor = Color.white;

		public Color BorderColor = Color.black;
		public int BorderThickness = 1;

		public bool TL_isRounded = false;
		public bool TR_isRounded = false;
		public bool BL_isRounded = false;
		public bool BR_isRounded = false;

		public int CornerRadius = 10;
		public TextureWrapMode WrapMode = TextureWrapMode.Clamp;

        Point _size = new Point();

		public Texture2D Generate()
		{
            // Calculate Size
            float dr = Mathf.Max(AspectRatio.x, AspectRatio.y);
            var ratio = new Point(Mathf.RoundToInt(AspectRatio.x / dr), Mathf.RoundToInt(AspectRatio.y / dr));
			_size = new Point(Resolution * ratio.x, Resolution * ratio.y);

			int offset = CornerRadius + BorderThickness;

            // LINES
            Point l = new Point( BL_isRounded ? offset : 0, _size.y -  (TL_isRounded ? offset : 0));
            Point r = new Point( BR_isRounded ? offset : 0, _size.y -  (TR_isRounded ? offset : 0));
            Point t = new Point(TL_isRounded ? offset : 0, _size.x - (TR_isRounded ? offset : 0));
            Point b = new Point(BL_isRounded ? offset : 0, _size.x - (BR_isRounded ? offset : 0));

			// CORNERS
			Circle TL = (TL_isRounded) ? new Circle(new Point(offset, _size.y - offset), offset, BorderThickness) : null;
			Circle TR = (TR_isRounded) ? new Circle(new Point(_size.x - offset, _size.y - offset), offset, BorderThickness ) : null;
			Circle BL = (BL_isRounded) ? new Circle(new Point(offset, offset), offset, BorderThickness) : null;
			Circle BR = (BR_isRounded) ? new Circle(new Point(_size.x - offset, offset), offset, BorderThickness) : null;

			var texture = new Texture2D(_size.x, _size.y, TextureFormat.ARGB32, false);

			for(int x = 0; x < _size.x; x++)
				for(int y = 0; y < _size.y; y++)
				{
                    Point p = new Point(x, y);
					Color color = FillColor;

					if ( Between(x, 0, BorderThickness-1) && Between(y, l.x, l.y) || Between(x, _size.x, _size.x - BorderThickness) && Between(y, r.x, r.y) ||
						 Between(y, 0, BorderThickness-1) && Between(x, b.x, b.y) || Between(y, _size.y, _size.y - BorderThickness) && Between(x, t.x, t.y) ||
					// CORNERS
						Between(x, 0, offset) && Between(y, _size.y, _size.y - offset) && TL != null && TL.IsBorder(p) || 
						Between(x, 0, offset) && Between(y, 0, offset) && BL != null && BL.IsBorder(p) ||
						Between(x, _size.x, _size.x - offset) && Between(y, _size.y, _size.y - offset) && TR != null && TR.IsBorder(p) || 
						Between(x, _size.x, _size.x - offset) && Between(y, 0, offset) && BR != null && BR.IsBorder(p)
						)
						color = BorderColor;
	
					if( TL != null && x < offset && y > _size.y - offset && !TL.IsInside(p) ||
						BL != null && x < offset && y < offset && !BL.IsInside(p)||
						TR != null && x > _size.x - offset && y > _size.y - offset && !TR.IsInside(p)||
						BR != null && x > _size.x - offset && y < offset && !BR.IsInside(p)
					){
						color = new Color(0,0,0,0);
					}
					texture.SetPixel(x, y, color);
				}	
			texture.wrapMode = TextureWrapMode.Clamp;
			//texture.alphaIsTransparency = true;
			texture.Apply();
			return texture;
		}

		bool Between(int value, int min, int max)
		{
			if (min > max)
			{
				var t = min;
				min = max;
				max = t;
			}
			return value >= min && value <= max;
		}
	}
    /// <summary>
    /// This class will generate a circular texture.
    /// </summary>
    public class Circle
	{
		public Point Center;
		public int Radius;
		public int BorderThickness;

		public Circle(Point center, int radius, int borderThickness = 0)
		{
			Center = center;
			Radius = radius;
			BorderThickness = borderThickness;
		}

		public Circle(int radius, int borderThickness = 0)
		{
			Center = new Point(0, 0);
			Radius = radius;
			BorderThickness = borderThickness;
		}

		public bool IsBorder(Point point)
		{
			var temp = Mathf.Pow(point.x - Center.x, 2) + Mathf.Pow(point.y - Center.y, 2);
			return temp < Mathf.Pow(Radius,2) && temp > Mathf.Pow(Radius-BorderThickness,2);
		}

		public bool IsInside(Point point)
		{
			return Mathf.Pow(point.x - Center.x, 2) + Mathf.Pow(point.y - Center.y, 2) < Mathf.Pow(Radius,2);
		}
	}
}