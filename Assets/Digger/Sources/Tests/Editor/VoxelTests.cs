using System;
using Digger;
using NUnit.Framework;
using UnityEngine;


public class VoxelTests
{
    [Test]
    public void VoxelFirstTextureIndex()
    {
        var voxel = new Voxel(1f);
        Debug.Log(Convert.ToString(voxel.FirstTextureIndex, 2).PadLeft(32, '0'));
        Assert.AreEqual(0, voxel.FirstTextureIndex);

        voxel.FirstTextureIndex = 3;
        Debug.Log(Convert.ToString(voxel.FirstTextureIndex, 2).PadLeft(32, '0'));
        Assert.AreEqual(3, voxel.FirstTextureIndex);

        voxel.FirstTextureIndex = 5;
        Debug.Log(Convert.ToString(voxel.FirstTextureIndex, 2).PadLeft(32, '0'));
        Assert.AreEqual(5, voxel.FirstTextureIndex);

        voxel.FirstTextureIndex = 31;
        Debug.Log(Convert.ToString(voxel.FirstTextureIndex, 2).PadLeft(32, '0'));
        Assert.AreEqual(31, voxel.FirstTextureIndex);

        voxel.FirstTextureIndex = 0;
        Debug.Log(Convert.ToString(voxel.FirstTextureIndex, 2).PadLeft(32, '0'));
        Assert.AreEqual(0, voxel.FirstTextureIndex);
    }

    [Test]
    public void VoxelSecondTextureIndex()
    {
        var voxel = new Voxel(1f);
        Debug.Log(Convert.ToString(voxel.SecondTextureIndex, 2).PadLeft(32, '0'));
        Assert.AreEqual(0, voxel.SecondTextureIndex);

        voxel.SecondTextureIndex = 3;
        Debug.Log(Convert.ToString(voxel.SecondTextureIndex, 2).PadLeft(32, '0'));
        Assert.AreEqual(3, voxel.SecondTextureIndex);

        voxel.SecondTextureIndex = 5;
        Debug.Log(Convert.ToString(voxel.SecondTextureIndex, 2).PadLeft(32, '0'));
        Assert.AreEqual(5, voxel.SecondTextureIndex);

        voxel.SecondTextureIndex = 31;
        Debug.Log(Convert.ToString(voxel.SecondTextureIndex, 2).PadLeft(32, '0'));
        Assert.AreEqual(31, voxel.SecondTextureIndex);

        voxel.SecondTextureIndex = 0;
        Debug.Log(Convert.ToString(voxel.SecondTextureIndex, 2).PadLeft(32, '0'));
        Assert.AreEqual(0, voxel.SecondTextureIndex);
    }

    [Test]
    public void VoxelNormalizedTextureLerp()
    {
        var voxel = new Voxel(1f);
        Assert.AreEqual(0, voxel.NormalizedTextureLerp);

        voxel.NormalizedTextureLerp = 1f;
        Assert.AreEqual(1, voxel.NormalizedTextureLerp, 0.001);

        voxel.NormalizedTextureLerp = 0.4f;
        Assert.AreEqual(0.4, voxel.NormalizedTextureLerp, 0.01);
    }

    [Test]
    public void VoxelNormalizedWetnessWeight()
    {
        var voxel = new Voxel(1f);
        Assert.AreEqual(0, voxel.NormalizedWetnessWeight);

        voxel.NormalizedWetnessWeight = 1f;
        Assert.AreEqual(1, voxel.NormalizedWetnessWeight, 0.001);

        voxel.NormalizedWetnessWeight = 3f / 7f;
        Assert.AreEqual(3.0 / 7.0, voxel.NormalizedWetnessWeight, 0.01);
    }

    [Test]
    public void VoxelNormalizedPuddlesWeight()
    {
        var voxel = new Voxel(1f);
        Assert.AreEqual(0, voxel.NormalizedPuddlesWeight);

        voxel.NormalizedPuddlesWeight = 1f;
        Assert.AreEqual(1, voxel.NormalizedPuddlesWeight, 0.001);

        voxel.NormalizedPuddlesWeight = 3f / 7f;
        Assert.AreEqual(3.0 / 7.0, voxel.NormalizedPuddlesWeight, 0.01);
    }

    [Test]
    public void VoxelNormalizedStreamsWeight()
    {
        var voxel = new Voxel(1f);
        Assert.AreEqual(0, voxel.NormalizedStreamsWeight);

        voxel.NormalizedStreamsWeight = 1f;
        Assert.AreEqual(1, voxel.NormalizedStreamsWeight, 0.001);

        voxel.NormalizedStreamsWeight = 3f / 7f;
        Assert.AreEqual(3.0 / 7.0, voxel.NormalizedStreamsWeight, 0.01);
    }

    [Test]
    public void VoxelNormalizedLavaWeight()
    {
        var voxel = new Voxel(1f);
        Assert.AreEqual(0, voxel.NormalizedLavaWeight);

        voxel.NormalizedLavaWeight = 1f;
        Assert.AreEqual(1, voxel.NormalizedLavaWeight, 0.001);

        voxel.NormalizedLavaWeight = 3f / 7f;
        Assert.AreEqual(3.0 / 7.0, voxel.NormalizedLavaWeight, 0.01);
    }

    [Test]
    public void VoxelAlteration()
    {
        var voxel = new Voxel(1f);
        Debug.Log(Convert.ToString(voxel.Alteration, 2).PadLeft(32, '0'));
        Assert.AreEqual(0, voxel.Alteration);

        voxel.Alteration = 3;
        Debug.Log(Convert.ToString(voxel.Alteration, 2).PadLeft(32, '0'));
        Assert.AreEqual(3, voxel.Alteration);

        voxel.Alteration = 5;
        Debug.Log(Convert.ToString(voxel.Alteration, 2).PadLeft(32, '0'));
        Assert.AreEqual(5, voxel.Alteration);

        voxel.Alteration = 2;
        Debug.Log(Convert.ToString(voxel.Alteration, 2).PadLeft(32, '0'));
        Assert.AreEqual(2, voxel.Alteration);

        voxel.Alteration = 0;
        Debug.Log(Convert.ToString(voxel.Alteration, 2).PadLeft(32, '0'));
        Assert.AreEqual(0, voxel.Alteration);
    }

    [Test]
    public void VoxelProperties()
    {
        var voxel = new Voxel(1f);
        Assert.AreEqual(0, voxel.Alteration);
        Assert.AreEqual(0, voxel.FirstTextureIndex);
        Assert.AreEqual(0, voxel.SecondTextureIndex);
        Assert.AreEqual(0, voxel.NormalizedTextureLerp);
        Assert.AreEqual(0, voxel.NormalizedWetnessWeight);
        Assert.AreEqual(0, voxel.NormalizedPuddlesWeight);
        Assert.AreEqual(0, voxel.NormalizedStreamsWeight);
        Assert.AreEqual(0, voxel.NormalizedLavaWeight);

        voxel.Alteration = 3;
        
        Assert.AreEqual(3, voxel.Alteration);
        Assert.AreEqual(0, voxel.FirstTextureIndex);
        Assert.AreEqual(0, voxel.SecondTextureIndex);
        Assert.AreEqual(0, voxel.NormalizedTextureLerp);
        Assert.AreEqual(0, voxel.NormalizedWetnessWeight);
        Assert.AreEqual(0, voxel.NormalizedPuddlesWeight);
        Assert.AreEqual(0, voxel.NormalizedStreamsWeight);
        Assert.AreEqual(0, voxel.NormalizedLavaWeight);
        
        voxel.FirstTextureIndex = 29;
        
        Assert.AreEqual(3, voxel.Alteration);
        Assert.AreEqual(29, voxel.FirstTextureIndex);
        Assert.AreEqual(0, voxel.SecondTextureIndex);
        Assert.AreEqual(0, voxel.NormalizedTextureLerp);
        Assert.AreEqual(0, voxel.NormalizedWetnessWeight);
        Assert.AreEqual(0, voxel.NormalizedPuddlesWeight);
        Assert.AreEqual(0, voxel.NormalizedStreamsWeight);
        Assert.AreEqual(0, voxel.NormalizedLavaWeight);
        
        voxel.Alteration = 1;
        
        Assert.AreEqual(1, voxel.Alteration);
        Assert.AreEqual(29, voxel.FirstTextureIndex);
        Assert.AreEqual(0, voxel.SecondTextureIndex);
        Assert.AreEqual(0, voxel.NormalizedTextureLerp);
        Assert.AreEqual(0, voxel.NormalizedWetnessWeight);
        Assert.AreEqual(0, voxel.NormalizedPuddlesWeight);
        Assert.AreEqual(0, voxel.NormalizedStreamsWeight);
        Assert.AreEqual(0, voxel.NormalizedLavaWeight);
        
        voxel.Alteration = 3;
        voxel.SecondTextureIndex = 15;
        
        Assert.AreEqual(3, voxel.Alteration);
        Assert.AreEqual(29, voxel.FirstTextureIndex);
        Assert.AreEqual(15, voxel.SecondTextureIndex);
        Assert.AreEqual(0, voxel.NormalizedTextureLerp);
        Assert.AreEqual(0, voxel.NormalizedWetnessWeight);
        Assert.AreEqual(0, voxel.NormalizedPuddlesWeight);
        Assert.AreEqual(0, voxel.NormalizedStreamsWeight);
        Assert.AreEqual(0, voxel.NormalizedLavaWeight);
        
        voxel.NormalizedTextureLerp = 0.4f;
        
        Assert.AreEqual(3, voxel.Alteration);
        Assert.AreEqual(29, voxel.FirstTextureIndex);
        Assert.AreEqual(15, voxel.SecondTextureIndex);
        Assert.AreEqual(0.4f, voxel.NormalizedTextureLerp, 0.1f);
        Assert.AreEqual(0, voxel.NormalizedWetnessWeight, 0.1f);
        Assert.AreEqual(0, voxel.NormalizedPuddlesWeight, 0.1f);
        Assert.AreEqual(0, voxel.NormalizedStreamsWeight, 0.1f);
        Assert.AreEqual(0, voxel.NormalizedLavaWeight, 0.1f);
        
        voxel.Alteration = 3;
        voxel.FirstTextureIndex = 29;
        voxel.SecondTextureIndex = 15;
        voxel.NormalizedWetnessWeight = 3f / 7f;
        
        Assert.AreEqual(3, voxel.Alteration);
        Assert.AreEqual(29, voxel.FirstTextureIndex);
        Assert.AreEqual(15, voxel.SecondTextureIndex);
        Assert.AreEqual(0.4f, voxel.NormalizedTextureLerp, 0.1f);
        Assert.AreEqual(3f / 7f, voxel.NormalizedWetnessWeight, 0.1f);
        Assert.AreEqual(0, voxel.NormalizedPuddlesWeight, 0.1f);
        Assert.AreEqual(0, voxel.NormalizedStreamsWeight, 0.1f);
        Assert.AreEqual(0, voxel.NormalizedLavaWeight, 0.1f);
        
        voxel.NormalizedPuddlesWeight = 4f / 7f;
        
        Assert.AreEqual(3, voxel.Alteration);
        Assert.AreEqual(29, voxel.FirstTextureIndex);
        Assert.AreEqual(15, voxel.SecondTextureIndex);
        Assert.AreEqual(0.4f, voxel.NormalizedTextureLerp, 0.1f);
        Assert.AreEqual(3f / 7f, voxel.NormalizedWetnessWeight, 0.1f);
        Assert.AreEqual(4f / 7f, voxel.NormalizedPuddlesWeight, 0.1f);
        Assert.AreEqual(0, voxel.NormalizedStreamsWeight, 0.1f);
        Assert.AreEqual(0, voxel.NormalizedLavaWeight, 0.1f);
        
        voxel.NormalizedStreamsWeight = 5f / 7f;
        
        Assert.AreEqual(3, voxel.Alteration);
        Assert.AreEqual(29, voxel.FirstTextureIndex);
        Assert.AreEqual(15, voxel.SecondTextureIndex);
        Assert.AreEqual(0.4f, voxel.NormalizedTextureLerp, 0.1f);
        Assert.AreEqual(3f / 7f, voxel.NormalizedWetnessWeight, 0.1f);
        Assert.AreEqual(4f / 7f, voxel.NormalizedPuddlesWeight, 0.1f);
        Assert.AreEqual(5f / 7f, voxel.NormalizedStreamsWeight, 0.1f);
        Assert.AreEqual(0, voxel.NormalizedLavaWeight, 0.1f);
        
        voxel.Alteration = 3;
        voxel.FirstTextureIndex = 29;
        voxel.SecondTextureIndex = 15;
        voxel.NormalizedLavaWeight = 6f / 7f;
        
        Assert.AreEqual(3, voxel.Alteration);
        Assert.AreEqual(29, voxel.FirstTextureIndex);
        Assert.AreEqual(15, voxel.SecondTextureIndex);
        Assert.AreEqual(0.4f, voxel.NormalizedTextureLerp, 0.1f);
        Assert.AreEqual(3f / 7f, voxel.NormalizedWetnessWeight, 0.1f);
        Assert.AreEqual(4f / 7f, voxel.NormalizedPuddlesWeight, 0.1f);
        Assert.AreEqual(5f / 7f, voxel.NormalizedStreamsWeight, 0.1f);
        Assert.AreEqual(6f / 7f, voxel.NormalizedLavaWeight, 0.1f);
    }
}