using Digger.NativeCollections;
using Unity.Collections;
using Unity.Jobs;
using NUnit.Framework;


public class NativeCounterTests
{
    struct ParallelIncrementCountTo : IJobParallelFor
    {
        public NativeCounter.Concurrent counter;
        public int countMask;

        public void Execute(int i)
        {
            if ((i & countMask) == 0)
                counter.Increment();
        }
    }

    struct ParallelDecrementCountTo : IJobParallelFor
    {
        public NativeCounter.Concurrent counter;
        public int countMask;

        public void Execute(int i)
        {
            if ((i & countMask) == 0)
                counter.Decrement();
        }
    }

    [Test]
    public void GetSetCount()
    {
        var counter = new NativeCounter(Allocator.Temp);
        Assert.AreEqual(0, counter.Count);
        counter.Count = 42;
        Assert.AreEqual(42, counter.Count);
        counter.Count = 3;
        Assert.AreEqual(3, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void Increment()
    {
        int count;
        var counter = new NativeCounter(Allocator.Temp);
        Assert.AreEqual(0, counter.Count);
        count = counter.Increment();
        Assert.AreEqual(1, count);
        Assert.AreEqual(1, counter.Count);
        count = counter.Increment();
        count = counter.Increment();
        Assert.AreEqual(3, count);
        Assert.AreEqual(3, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void ConcurrentIncrement()
    {
        int count;
        var counter = new NativeCounter(Allocator.Temp);
        var concurrentCounter = counter.ToConcurrent();
        Assert.AreEqual(0, counter.Count);
        count = concurrentCounter.Increment();
        Assert.AreEqual(1, count);
        Assert.AreEqual(1, counter.Count);
        count = concurrentCounter.Increment();
        count = concurrentCounter.Increment();
        Assert.AreEqual(3, count);
        Assert.AreEqual(3, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void SetCountIncrement()
    {
        int count;
        var counter = new NativeCounter(Allocator.Temp);
        Assert.AreEqual(0, counter.Count);
        count = counter.Increment();
        Assert.AreEqual(1, count);
        Assert.AreEqual(1, counter.Count);
        counter.Count = 40;
        Assert.AreEqual(40, counter.Count);
        count = counter.Increment();
        count = counter.Increment();
        Assert.AreEqual(42, count);
        Assert.AreEqual(42, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void SetCountConcurrentIncrement()
    {
        var counter = new NativeCounter(Allocator.Temp);
        var concurrentCounter = counter.ToConcurrent();
        Assert.AreEqual(0, counter.Count);
        concurrentCounter.Increment();
        Assert.AreEqual(1, counter.Count);
        counter.Count = 40;
        Assert.AreEqual(40, counter.Count);
        concurrentCounter.Increment();
        concurrentCounter.Increment();
        Assert.AreEqual(42, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void ParallelIncrement()
    {
        var counter = new NativeCounter(Allocator.Temp);
        var jobData = new ParallelIncrementCountTo();
        jobData.counter = counter.ToConcurrent();
        // Count every second item
        jobData.countMask = 1;
        jobData.Schedule(1000000, 1).Complete();
        Assert.AreEqual(500000, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void ParallelIncrementSetCount()
    {
        var counter = new NativeCounter(Allocator.Temp);
        var jobData = new ParallelIncrementCountTo();
        jobData.counter = counter.ToConcurrent();
        counter.Count = 42;
        // Count every second item
        jobData.countMask = 1;
        jobData.Schedule(1000, 1).Complete();
        Assert.AreEqual(542, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void Decrement()
    {
        int count;
        var counter = new NativeCounter(Allocator.Temp);
        Assert.AreEqual(0, counter.Count);
        count = counter.Decrement();
        Assert.AreEqual(-1, count);
        Assert.AreEqual(-1, counter.Count);
        count = counter.Decrement();
        count = counter.Decrement();
        Assert.AreEqual(-3, count);
        Assert.AreEqual(-3, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void ConcurrentDecrement()
    {
        int count;
        var counter = new NativeCounter(Allocator.Temp);
        var concurrentCounter = counter.ToConcurrent();
        Assert.AreEqual(0, counter.Count);
        count = concurrentCounter.Decrement();
        Assert.AreEqual(-1, count);
        Assert.AreEqual(-1, counter.Count);
        count = concurrentCounter.Decrement();
        count = concurrentCounter.Decrement();
        Assert.AreEqual(-3, count);
        Assert.AreEqual(-3, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void SetCountDecrement()
    {
        int count;
        var counter = new NativeCounter(Allocator.Temp);
        Assert.AreEqual(0, counter.Count);
        count = counter.Decrement();
        Assert.AreEqual(-1, count);
        Assert.AreEqual(-1, counter.Count);
        counter.Count = 40;
        Assert.AreEqual(40, counter.Count);
        count = counter.Decrement();
        count = counter.Decrement();
        Assert.AreEqual(38, count);
        Assert.AreEqual(38, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void SetCountConcurrentDecrement()
    {
        var counter = new NativeCounter(Allocator.Temp);
        var concurrentCounter = counter.ToConcurrent();
        Assert.AreEqual(0, counter.Count);
        concurrentCounter.Decrement();
        Assert.AreEqual(-1, counter.Count);
        counter.Count = 40;
        Assert.AreEqual(40, counter.Count);
        concurrentCounter.Decrement();
        concurrentCounter.Decrement();
        Assert.AreEqual(38, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void ParallelDecrement()
    {
        var counter = new NativeCounter(Allocator.Temp);
        var jobData = new ParallelDecrementCountTo();
        jobData.counter = counter.ToConcurrent();
        // Count every second item
        jobData.countMask = 1;
        jobData.Schedule(1000000, 1).Complete();
        Assert.AreEqual(-500000, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void ParallelDecrementSetCount()
    {
        var counter = new NativeCounter(Allocator.Temp);
        var jobData = new ParallelDecrementCountTo();
        jobData.counter = counter.ToConcurrent();
        counter.Count = -42;
        // Count every second item
        jobData.countMask = 1;
        jobData.Schedule(1000, 1).Complete();
        Assert.AreEqual(-542, counter.Count);
        counter.Dispose();
    }
}

public class NativePerThreadCounterTests
{
    struct ParallelCountTo : IJobParallelFor
    {
        public NativePerThreadCounter.Concurrent counter;
        public int countMask;

        public void Execute(int i)
        {
            if ((i & countMask) == 0)
                counter.Increment();
        }
    }

    [Test]
    public void GetSetCount()
    {
        var counter = new NativePerThreadCounter(Allocator.Temp);
        Assert.AreEqual(0, counter.Count);
        counter.Count = 42;
        Assert.AreEqual(42, counter.Count);
        counter.Count = 3;
        Assert.AreEqual(3, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void Increment()
    {
        var counter = new NativePerThreadCounter(Allocator.Temp);
        Assert.AreEqual(0, counter.Count);
        counter.Increment();
        Assert.AreEqual(1, counter.Count);
        counter.Increment();
        counter.Increment();
        Assert.AreEqual(3, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void ConcurrentIncrement()
    {
        var counter = new NativePerThreadCounter(Allocator.Temp);
        var concurrentCounter = counter.ToConcurrent();
        Assert.AreEqual(0, counter.Count);
        concurrentCounter.Increment();
        Assert.AreEqual(1, counter.Count);
        concurrentCounter.Increment();
        concurrentCounter.Increment();
        Assert.AreEqual(3, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void SetCountIncrement()
    {
        var counter = new NativePerThreadCounter(Allocator.Temp);
        Assert.AreEqual(0, counter.Count);
        counter.Increment();
        Assert.AreEqual(1, counter.Count);
        counter.Count = 40;
        Assert.AreEqual(40, counter.Count);
        counter.Increment();
        counter.Increment();
        Assert.AreEqual(42, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void SetCountConcurrentIncrement()
    {
        var counter = new NativePerThreadCounter(Allocator.Temp);
        var concurrentCounter = counter.ToConcurrent();
        Assert.AreEqual(0, counter.Count);
        concurrentCounter.Increment();
        Assert.AreEqual(1, counter.Count);
        counter.Count = 40;
        Assert.AreEqual(40, counter.Count);
        concurrentCounter.Increment();
        concurrentCounter.Increment();
        Assert.AreEqual(42, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void ParallelIncrement()
    {
        var counter = new NativePerThreadCounter(Allocator.Temp);
        var jobData = new ParallelCountTo();
        jobData.counter = counter.ToConcurrent();
        // Count every second item
        jobData.countMask = 1;
        jobData.Schedule(1000000, 1).Complete();
        Assert.AreEqual(500000, counter.Count);
        counter.Dispose();
    }

    [Test]
    public void ParallelIncrementSetCount()
    {
        var counter = new NativePerThreadCounter(Allocator.Temp);
        var jobData = new ParallelCountTo();
        jobData.counter = counter.ToConcurrent();
        counter.Count = 42;
        // Count every second item
        jobData.countMask = 1;
        jobData.Schedule(1000, 1).Complete();
        Assert.AreEqual(542, counter.Count);
        counter.Dispose();
    }
}