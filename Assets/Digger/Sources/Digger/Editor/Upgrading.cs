using System;
using System.IO;
using System.Linq;
using Digger.Unsafe;
using Unity.Collections;
using UnityEngine;

namespace Digger
{
    public static class Upgrading
    {
#pragma warning disable 649
        private struct LegacyVoxel
        {
            public const sbyte TextureOffset = 50;
            public const sbyte TextureNearSurfaceOffset = 10;

            public float Value;

            /// <summary>
            /// 0 => not altered, no visual mesh generated.
            /// 1 => not altered but visual mesh must be generated as terrain surface.
            /// [10, 50[ => altered, near terrain surface. Texture index is given by Altered - 10.
            /// [50, 90[ => altered, not near terrain surface. Texture index is given by Altered - 50.
            /// </summary>
            public sbyte Altered;
        }
#pragma warning restore 649


        public static bool HasLegacyFiles(DiggerSystem diggerSystem)
        {
            var basePath = diggerSystem.BasePathData;
            var internalPath = Path.Combine(basePath, ".internal");
            var internalDir = new DirectoryInfo(internalPath);

            if (!internalDir.Exists) {
                return false;
            }

            return !internalDir.EnumerateFiles($"*.{DiggerSystem.VoxelFileExtension}").Select(info => info.Extension == $".{DiggerSystem.VoxelFileExtension}").Any() &&
                   (internalDir.EnumerateFiles($"*.{DiggerSystem.VoxelFileExtensionLegacy}").Select(info => info.Extension == $".{DiggerSystem.VoxelFileExtensionLegacy}").Any() ||
                    internalDir.EnumerateFiles($"*.{DiggerSystem.VoxelFileExtensionLegacy}_v*")
                               .Select(info => info.Extension.StartsWith($".{DiggerSystem.VoxelFileExtensionLegacy}_v")).Any());
        }

        public static void UpgradeDiggerData(DiggerSystem diggerSystem)
        {
            var basePath = diggerSystem.BasePathData;
            var internalPath = Path.Combine(basePath, ".internal");
            var internalDir = new DirectoryInfo(internalPath);

            if (!internalDir.Exists) {
                Debug.Log(
                    $"No DiggerData found for '{diggerSystem.Terrain.name}' at '{internalDir.FullName}'. Nothing to upgrade.");
                return;
            }

            if (!HasLegacyFiles(diggerSystem))
                return;

            Debug.Log($"Legacy Digger files detected for terrain '{diggerSystem.Terrain.name}' at '{internalDir.FullName}'. Upgrading...");
            BackupDirectory(new DirectoryInfo(basePath));

            foreach (var file in internalDir.GetFiles($"*.{DiggerSystem.VoxelFileExtensionLegacy}")) {
                if (file.Extension != $".{DiggerSystem.VoxelFileExtensionLegacy}")
                    continue;

                var newPath = file.FullName.Replace($".{DiggerSystem.VoxelFileExtensionLegacy}", $".{DiggerSystem.VoxelFileExtension}");
                var rawBytes = File.ReadAllBytes(file.FullName);
                Voxel[] voxelArray = null;
                UpgradeVoxels(diggerSystem.SizeVox, rawBytes, ref voxelArray);
                PersistUpgradedVoxels(newPath, voxelArray);
                file.Delete();
                Debug.Log($"Upgraded file '{file.FullName}' to '{newPath}'");
            }

            foreach (var file in internalDir.GetFiles($"*.{DiggerSystem.VoxelFileExtensionLegacy}_v*")) {
                if (!file.Extension.StartsWith($".{DiggerSystem.VoxelFileExtensionLegacy}_v"))
                    continue;

                var newPath = file.FullName.Replace($".{DiggerSystem.VoxelFileExtensionLegacy}_v", $".{DiggerSystem.VoxelFileExtension}_v");
                var rawBytes = File.ReadAllBytes(file.FullName);
                Voxel[] voxelArray = null;
                UpgradeVoxels(diggerSystem.SizeVox, rawBytes, ref voxelArray);
                PersistUpgradedVoxels(newPath, voxelArray);
                file.Delete();
                Debug.Log($"Upgraded file '{file.FullName}' to '{newPath}'");
            }
        }

        private static void UpgradeVoxels(int sizeVox, byte[] rawBytes, ref Voxel[] voxelArray)
        {
            LegacyVoxel[] legacyVoxelArray = null;
            ReadLegacyVoxelBytes(sizeVox, rawBytes, ref legacyVoxelArray);

            if (voxelArray == null)
                voxelArray = new Voxel[sizeVox * sizeVox * sizeVox];

            for (var i = 0; i < legacyVoxelArray.Length; i++) {
                voxelArray[i] = UpgradeVoxel(legacyVoxelArray[i]);
            }
        }

        private static void PersistUpgradedVoxels(string path, Voxel[] voxelArray)
        {
            var voxels = new NativeArray<Voxel>(voxelArray, Allocator.Temp);
            var bytes = new NativeSlice<Voxel>(voxels).SliceConvert<byte>();
            File.WriteAllBytes(path, bytes.ToArray());
            voxels.Dispose();
        }

        private static void BackupDirectory(DirectoryInfo sourcePath)
        {
            var projectDir = new DirectoryInfo(Application.dataPath).Parent;
            if (projectDir == null || !projectDir.Exists)
                return;

            Debug.Log($"Project directory = '{projectDir.FullName}'");
            var relDir = sourcePath.FullName.Replace(projectDir.FullName, "").Trim('/').Trim('\\').Trim(Path.PathSeparator);
            Debug.Log($"Relative directory = '{relDir}'");
            var destinationPath = projectDir.CreateSubdirectory("DiggerBackup").CreateSubdirectory(relDir);

            Debug.Log($"Backuping '{sourcePath.FullName}' directory to '{destinationPath.FullName}'");

            //Now Create all of the directories
            foreach (var dirPath in Directory.GetDirectories(sourcePath.FullName, "*",
                                                             SearchOption.AllDirectories))
                Directory.CreateDirectory(dirPath.Replace(sourcePath.FullName, destinationPath.FullName));

            //Copy all the files & Replaces any files with the same name
            foreach (var newPath in Directory.GetFiles(sourcePath.FullName, "*.*",
                                                       SearchOption.AllDirectories))
                File.Copy(newPath, newPath.Replace(sourcePath.FullName, destinationPath.FullName), true);
        }

        private static void ReadLegacyVoxelBytes(int sizeVox, byte[] rawBytes, ref LegacyVoxel[] voxelArray)
        {
            if (voxelArray == null)
                voxelArray = new LegacyVoxel[sizeVox * sizeVox * sizeVox];

            var voxelBytes = new NativeArray<byte>(rawBytes, Allocator.Temp);
            var bytes = new NativeSlice<byte>(voxelBytes);
            var voxelSlice = bytes.SliceConvert<LegacyVoxel>();
            DirectNativeCollectionsAccess.CopyTo(voxelSlice, voxelArray);
            voxelBytes.Dispose();
        }

        private static Voxel UpgradeVoxel(LegacyVoxel legacyVoxel)
        {
            var voxel = new Voxel {Value = legacyVoxel.Value};

            var absAltered = Math.Abs(legacyVoxel.Altered);
            if (absAltered == 0) {
                voxel.Alteration = Voxel.Unaltered;
            } else if (absAltered == 1) {
                voxel.Alteration = Voxel.OnSurface;
            } else if (absAltered >= LegacyVoxel.TextureNearSurfaceOffset && absAltered < LegacyVoxel.TextureOffset) {
                voxel.Alteration = absAltered == legacyVoxel.Altered ? Voxel.NearAboveSurface : Voxel.NearBelowSurface;
                voxel.FirstTextureIndex = (uint) (absAltered - LegacyVoxel.TextureNearSurfaceOffset);
            } else if (absAltered >= LegacyVoxel.TextureOffset) {
                voxel.Alteration = absAltered == legacyVoxel.Altered ? Voxel.FarAboveSurface : Voxel.FarBelowSurface;
                voxel.FirstTextureIndex = (uint) (absAltered - LegacyVoxel.TextureOffset);
            }

            return voxel;
        }
    }
}